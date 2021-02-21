defmodule Ssauction.SingleAuction do
  @moduledoc """
  The SingleAuction context: public interface for working with a single auction
  """

  import Ecto.Query, warn: false
  alias Ssauction.Repo

  alias Ssauction.{Auction, Team, AllPlayer, Player, Bid, OrderedPlayer, RosteredPlayer, BidLog}
  alias Ssauction.User

  alias SsauctionWeb.Resolvers.SingleAuction

  @doc """
  Creates an auction.

  """
  def create_auction(name: name,
                     year_range: year_range,
                     nominations_per_team: nominations_per_team,
                     seconds_before_autonomination: seconds_before_autonomination,
                     new_nominations_created: new_nominations_created,
                     initial_bid_timeout_seconds: initial_bid_timeout_seconds,
                     bid_timeout_seconds: bid_timeout_seconds,
                     players_per_team: players_per_team,
                     must_roster_all_players: must_roster_all_players,
                     team_dollars_per_player: team_dollars_per_player,
                     started_or_paused_at: started_or_paused_at) do
    auction =
      %Auction{
        name: name,
        year_range: year_range,
        nominations_per_team: nominations_per_team,
        seconds_before_autonomination: seconds_before_autonomination,
        new_nominations_created: new_nominations_created,
        initial_bid_timeout_seconds: initial_bid_timeout_seconds,
        bid_timeout_seconds: bid_timeout_seconds,
        players_per_team: players_per_team,
        must_roster_all_players: must_roster_all_players,
        team_dollars_per_player: team_dollars_per_player,
        started_or_paused_at: started_or_paused_at
        } |> Repo.insert!

    q = from p in AllPlayer,
          where: p.year_range == ^year_range,
          select: p
    Repo.all(q)
    |> Enum.each(fn player -> %Player{}
                              |> Player.changeset(%{
                                   year_range: player.year_range,
                                   name: player.name,
                                   ssnum: player.ssnum,
                                   position: player.position,
                                   auction_id: auction.id
                                 })
                              |> Repo.insert!
                 end)
    auction
  end

  @doc """
  Deletes an auction.

  """
  def delete_auction(auction = %Auction{}) do
    Repo.delete_all(from bl in BidLog, where: bl.auction_id == ^auction.id)
    Repo.delete_all(from op in OrderedPlayer, where: op.auction_id == ^auction.id)
    Repo.all(from t in Team, where: t.auction_id == ^auction.id)
    |> Enum.each(fn team ->
                   Repo.delete_all(from op in OrderedPlayer, where: op.team_id == ^team.id)
                   Repo.all(from b in Bid, where: b.team_id == ^team.id)
                   |> Enum.each(fn bid ->
                                  player = Repo.preload(bid, [:player]).player
                                  if player do
                                    player
                                    |> Ecto.Changeset.change(%{bid_id: nil})
                                    |> Repo.update
                                  end
                                  Repo.delete!(bid)
                                end)
                   Repo.all(from rp in RosteredPlayer, where: rp.team_id == ^team.id)
                   |> Enum.each(fn rostered_player ->
                                  player = Repo.preload(rostered_player, [:player]).player
                                  if player do
                                    player
                                    |> Ecto.Changeset.change(%{rostered_player_id: nil})
                                    |> Repo.update
                                  end
                                  Repo.delete!(rostered_player)
                                end)
                   Repo.delete_all(from r in "teams_users", where: r.team_id == ^team.id, select: [r.id, r.team_id, r.user_id])
                   Repo.delete!(team)
                 end)
    Repo.delete_all(from r in "auctions_users", where: r.auction_id == ^auction.id, select: [r.id, r.auction_id, r.user_id])
    Repo.delete_all(from p in Player, where: p.auction_id == ^auction.id)
    Repo.delete!(auction)
  end

  @doc """
  Returns all auctions.

  Raises `Ecto.NoResultsError` if no auction was found.
  """
  def get_all_auctions() do
    Repo.all(Auction)
  end

  @doc """
  Searches for expired bids in active auctions and roster them

  """
  def check_for_expired_bids() do
    q = from a in Auction, where: a.active, select: a.id
    Repo.all(q)
    |> Enum.each(&check_for_expired_bids/1)
  end

  @doc """
  Searches for expired bids in the auction and roster them

  """
  def check_for_expired_bids(auction_id) do
    auction_bids = from a in Auction,
                     where: a.id == ^auction_id,
                     join: bids in assoc(a, :bids),
                     select: bids
    open_bids = from b in subquery(auction_bids),
                  where: not b.closed
    Repo.all(open_bids)
    |> Enum.each(&check_for_expired_bid/1)
  end

  @doc """
  If this bid is expired, close it and roster the player

  """
  def check_for_expired_bid(bid = %Bid{}) do
    {:ok, now} = DateTime.now("Etc/UTC")
    if DateTime.diff(now, bid.expires_at) >= 0 do
      Bid.changeset(bid, %{closed: true})
      |> Repo.update!()
      roster_player_and_delete_bid(bid)
    end
  end

  @doc """
  Searches for teams ready to be given new nominations in active auctions

  """

  def check_for_new_nominations() do
    q = from a in Auction, where: a.active
    Repo.all(q)
    |> Enum.each(&check_for_new_nominations/1)
  end

  @doc """
  Searches for teams ready to be given new nominations in the auction

  """

  def check_for_new_nominations(auction = %Auction{}) do
    if auction.new_nominations_created == "time" do
      for team <- list_teams(auction) do
        check_for_new_nominations(team, auction)
      end
    end
  end

  @doc """
  Searches if the team is ready to be given new nominations

  """

  def check_for_new_nominations(team = %Team{}, auction = %Auction{}) do
    {:ok, now} = DateTime.now("Etc/UTC")
    if DateTime.diff(now, team.new_nominations_open_at) >= 0 do
      give_team_new_nominations(team, auction, auction.nominations_per_team)
    end
  end

  @doc """
  Searches for teams with expired nominations in active auctions and auto-nominate for them

  """

  def check_for_expired_nominations() do
    q = from a in Auction, where: a.active
    Repo.all(q)
    |> Enum.each(&check_for_expired_nominations/1)
  end

  @doc """
  Searches for teams with expired nominations in the auction and auto-nominate for them

  """

  def check_for_expired_nominations(auction = %Auction{}) do
    for team <- list_teams(auction) do
      check_for_expired_nominations(team, auction)
    end
  end

  @doc """
  Auto-nominate if the team has expired nomination

  """

  def check_for_expired_nominations(team = %Team{}, auction = %Auction{}) do
    {:ok, now} = DateTime.now("Etc/UTC")
    if team.time_nominations_expire != nil and DateTime.diff(now, team.time_nominations_expire) >= 0 do
      auto_nominate(team, auction)
    end
  end

  @doc """
  Auto-nominate all of the team's open nominations

  """

  defp auto_nominate(team = %Team{}, auction = %Auction{}) do
    if num_players_in_nomination_queue(auction) > 0 do
      if team.unused_nominations > 0 do
        for _ <- 1..team.unused_nominations do
          if team_has_open_roster_spot?(team, auction) and team_dollars_remaining_for_bids_including_hidden(team) > 0 do
            player = next_in_nomination_queue(auction)
            args = %{bid_amount: 1}
            SingleAuction.submit_bid_changeset(auction, team, player, args, nil)
            remove_from_nomination_queue(player, auction)
          end
        end
        team
        |> Team.changeset(%{time_nominations_expire: nil,
                            unused_nominations: 0})
        |> Repo.update
        publish_team_info_change(team.id)
        SingleAuction.publish_auction_teams_info_change(auction)
      end
    end
  end

  @doc """
  Return the number of players in the auction's auto-nomination queue

  """

  defp num_players_in_nomination_queue(auction = %Auction{}) do
    query = from a in Auction,
              where: a.id == ^auction.id,
              join: ordered_players in assoc(a, :ordered_players),
              select: ordered_players.id
    Repo.aggregate(query, :count, :id)
  end

  @doc """
  Roster the player from this bid and delete the bid

  """
  def roster_player_and_delete_bid(bid = %Bid{}) do
    bid = Repo.preload(bid, [:player, :team, :auction])
    auction = bid.auction
    team = bid.team
    player = bid.player
    rostered_player =
      %RosteredPlayer{
        cost: bid.bid_amount,
        player: player
      }
    rostered_player = Ecto.build_assoc(team, :rostered_players, rostered_player)
    rostered_player = Ecto.build_assoc(auction, :rostered_players, rostered_player)
    Repo.insert!(rostered_player)
    nominating_team = get_team_by_id!(bid.nominated_by)
    delete_bid(bid, auction, team, player, nominating_team)
    log_bid(bid, auction, team, player, "R")
    update_unused_nominations(nominating_team, auction)
    SingleAuction.publish_roster_change(auction, team)
    SingleAuction.publish_player_info_change(player)
  end

  @doc """
  Delete the bid

  """
  def delete_bid(bid = %Bid{}) do
    bid = Repo.preload(bid, [:player, :team, :auction])
    auction = bid.auction
    team = bid.team
    player = bid.player
    nominating_team = get_team_by_id!(bid.nominated_by)
    delete_bid(bid, auction, team, player, nominating_team)
  end


  def delete_bid(bid = %Bid{}, auction = %Auction{}, team = %Team{}, player = %Player{}, nominating_team = %Team{}) do
    player
    |> Ecto.Changeset.change(%{bid_id: nil})
    |> Repo.update
    bid
    |> Ecto.Changeset.change
    |> Repo.delete
    SingleAuction.publish_bid_change(auction, team)
    SingleAuction.publish_queueable_players_change(team)
    publish_team_info_change(team.id)
    publish_team_info_change(nominating_team.id)
    SingleAuction.publish_auction_teams_info_change(auction)
  end

  defp update_unused_nominations(team = %Team{}, auction = %Auction{}) do
    if auction.new_nominations_created == "auction" do
      team = Repo.get(Team, team.id)
      give_team_new_nominations(team, auction, 1)
    end
  end

  defp give_team_new_nominations(team = %Team{}, auction = %Auction{}, num_nominations) do
    open_roster_spots = open_roster_spots(team, auction)
    new_unused_nominations = Enum.min([team.unused_nominations+num_nominations,
                                       open_roster_spots])
    if new_unused_nominations > 0 do
      {:ok, now} = DateTime.now("Etc/UTC")
      now = now
        |> DateTime.truncate(:second)
        |> DateTime.add(-now.second, :second)
      team
      |> Team.changeset(%{unused_nominations: new_unused_nominations,
                          time_nominations_expire: DateTime.add(now, auction.seconds_before_autonomination, :second),
                          new_nominations_open_at: DateTime.add(team.new_nominations_open_at, 24*60*60, :second)})
      |> Repo.update
      publish_team_info_change(team.id)
      SingleAuction.publish_auction_teams_info_change(auction)
    end
  end

  @doc """
  Update a team's info after a nomination

  """
  def update_team_info_post_nomination(team = %Team{}, args) do
    team
    |> Team.changeset(%{unused_nominations: team.unused_nominations-1})
    |> Repo.update
    publish_team_info_change(team.id)
    Repo.get(Auction, team.auction_id)
    |> SingleAuction.publish_auction_teams_info_change
  end

  defp publish_team_info_change(team_id) do
    Repo.get(Team, team_id)
    |> SingleAuction.publish_team_info_change
  end

  # defp publish_player_info_change(player_id) do
  #   Repo.get(Player, player_id)
  #   |> SingleAuction.publish_player_info_change
  # end

  @doc """
  Returns the auction with the given `id`.

  Raises `Ecto.NoResultsError` if no auction was found.
  """
  def get_auction_by_id!(id) do
    Repo.get!(Auction, id)
  end

  @doc """
  Returns a list of teams in the auction

  """
  def list_teams(auction = %Auction{}) do
    Repo.preload(auction, [:teams]).teams
  end

  @doc """
  Returns the team with the given `id`.

  Raises `Ecto.NoResultsError` if no team was found.
  """
  def get_team_by_id!(id) do
    Repo.get!(Team, id)
  end

  @doc """
  Returns the team in the indicated auction with the indicated user.

  """
  def get_team_by_user_and_auction(user = %User{}, auction = %Auction{}) do
    [team] = Enum.filter(Repo.preload(user, [:teams]).teams,
                         fn(team) -> team.auction_id == auction.id end)
    team
  end

  @doc """
  Returns a query of all players in the auction's bids

  """
  def players_in_auction_bids_query(auction = %Auction{}) do
    from a in Auction,
      where: a.id == ^auction.id,
      join: bids in assoc(a, :bids),
      join: player in assoc(bids, :player),
      select: player
  end

  @doc """
  Returns a query of all players rostered in the auction

  """
  def players_rostered_in_auction_query(auction = %Auction{}) do
    from a in Auction,
      where: a.id == ^auction.id,
      join: rostered_players in assoc(a, :rostered_players),
      join: player in assoc(rostered_players, :player),
      select: player
  end

  @doc """
  Returns a query of all players in the auction

  """
  def players_in_auction_query(auction = %Auction{}) do
    from player in Player,
      where: player.auction_id == ^auction.id,
      select: player
  end

  @doc """
  Returns a query of all players in the team's nomination queue

  """
  def players_in_team_nomination_queue_query(team = %Team{}) do
    from t in Team,
      where: t.id == ^team.id,
      join: ordered_players in assoc(t, :ordered_players),
      join: player in assoc(ordered_players, :player),
      select: player
  end

  @doc """
  Returns a the largest rank of the players in the team's nomination queue

  """
  def largest_rank_in_team_nomination_queue(team = %Team{}) do
    query = from t in Team,
              where: t.id == ^team.id,
              join: ordered_players in assoc(t, :ordered_players),
              select: ordered_players.rank,
              order_by: ordered_players.rank
    ranks = Repo.all(query)
    case ranks do
      [] ->
        0

      _ ->
        Enum.max(ranks)
    end
  end

 defp smallest_rank_in_auction_nomination_queue(auction = %Auction{}) do
    query = from a in Auction,
              where: a.id == ^auction.id,
              join: ordered_players in assoc(a, :ordered_players),
              select: ordered_players.rank,
              order_by: ordered_players.rank
    ranks = Repo.all(query)
    case ranks do
      [] ->
        nil

      _ ->
        Enum.min(ranks)
    end
  end

  @doc """
  Returns a the player at the top (lowest rank) of the auction's auto-nomination queue

  """
  def next_in_nomination_queue(auction = %Auction{}) do
    rank_of_next = smallest_rank_in_auction_nomination_queue(auction)
    ordered_player = Repo.one!(from op in OrderedPlayer,
                               where: op.auction_id == ^auction.id and op.rank == ^rank_of_next)
    get_player_by_id!(ordered_player.player_id)
  end

  @doc """
  Returns a query for players who can be added to thhe team's nomination queue

  """
  def queueable_players_query(team = %Team{}) do
    auction = get_auction_by_id!(team.auction_id)

    bid_players = players_in_auction_bids_query(auction)
    rostered_players = players_rostered_in_auction_query(auction)
    queued_players = players_in_team_nomination_queue_query(team)

    from player in Player,
      where: player.auction_id == ^auction.id,
      select: player,
      except_all: ^bid_players,
      except_all: ^rostered_players,
      except_all: ^queued_players
  end

  @doc """
  Returns a list of players (sorted by id) who can be added to the team's nomination queue

  """
  def queueable_players(team = %Team{}) do
    query = queueable_players_query(team)

    Repo.all(from p in subquery(query), order_by: p.id)
  end


  @doc """
  Returns true if the player can be added to the team's nomination queue

  """
  def queueable_player?(player = %Player{}, team = %Team{}) do
    query = queueable_players_query(team)

    Enum.any?(Repo.all(from p in subquery(query), order_by: p.id,  select: p.id),
              fn id -> id == player.id end)
  end

  @doc """
  Returns a list of users in the team

  """
  def list_users(team = %Team{}) do
    Repo.preload(team, [:users]).users
  end

  @doc """
  Returns the player with the given `id`.

  Raises `Ecto.NoResultsError` if no player was found.
  """
  def get_player_by_id!(id) do
    Repo.get!(Player, id)
  end

  @doc """
  Returns a list of bids for all teams in the auction

  """
  def list_bids_in_auction!(auction = %Auction{}) do
    Repo.preload(auction, [:bids]).bids
  end

  @doc """
  Returns the bid with the given `id`.

  Raises `Ecto.NoResultsError` if no player was found.
  """
  def get_bid_by_id!(id) do
    Repo.get!(Bid, id)
  end

  @doc """
  Returns the bid associated with the player
  """
  def get_players_bid!(player = %Player{}) do
    get_bid_by_id!(player.bid_id)
  end

  @doc """
  Returns true if the user is able to change the auction

  """
  def user_is_auction_admin?(user = %User{}, auction = %Auction{}) do
    case user.super do
      true -> true
      false ->
        query = from a in Auction,
                  where: a.id == ^auction.id,
                  join: user in assoc(a, :admins),
                  select: user.id
        Enum.any?(Repo.all(query), fn id -> id == user.id end)
    end
  end

  def user_is_auction_admin?(_, _) do
    false
  end

  @doc """
  Returns true if the team is in the auction

  """
  def team_is_in_auction?(team = %Team{}, auction = %Auction{}) do
    Enum.member?(list_teams(auction), team)
  end

  @doc """
  Returns true if the user is a member of the team

  """
  def user_is_team_member?(user = %User{}, team = %Team{}) do
    Enum.member?(Repo.preload(team, [:users]).users, user)
  end

  @doc """
  Returns true if the player is rostered in the auction

  """
  def player_is_rostered?(player = %Player{}) do
    # Enum.find(Repo.preload(auction, [:rostered_players]).rostered_players,
    #           fn p -> p.id == player.id end) != nil
    player.rostered_player_id != nil
  end

  @doc """
  Returns the number of open roster spots for a team

  """
  def open_roster_spots(team = %Team{}, auction = %Auction{}) do
    auction.players_per_team - number_of_rostered_players_in_team(team) - number_of_bids_for_team(team)
  end

  @doc """
  Returns true if the team has an open roster spot for a bid

  """
  def team_has_open_roster_spot?(team = %Team{}, auction = %Auction{}) do
    open_roster_spots(team, auction) > 0
  end

  @doc """
  Returns true if the player is in the auction's bid

  """
  def player_in_bids?(player = %Player{}) do
    player.bid_id != nil
  end

  @doc """
  Returns the number of rostered players in a team

  """
  def number_of_rostered_players_in_team(team = %Team{}) do
    team
    |> Ecto.assoc(:rostered_players)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Returns the number of bids a team has

  """
  def number_of_bids_for_team(team = %Team{}) do
    team
    |> Ecto.assoc(:bids)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Returns the number of dollars each team has in the auction

  """

  def dollars_per_team(auction = %Auction{}) do
    auction.players_per_team * auction.team_dollars_per_player
  end

  @doc """
  Returns all open bids for a team

  """
  def open_bids(team = %Team{}) do
    team_bids = from t in Team,
                  where: t.id == ^team.id,
                  join: bids in assoc(t, :bids),
                  select: bids
    Repo.all(from b in subquery(team_bids), where: not b.closed)
  end

  @doc """
  Returns the number of dollars the team has in open bids (not counting hidden high bids)

  """

  def team_dollars_bid(team = %Team{}) do
    Enum.sum(for b <- open_bids(team), do: b.bid_amount)
  end

  @doc """
  Returns the number of dollars the team has in open bids (counting hidden high bids)

  """

  defp team_dollars_bid_including_hidden(team = %Team{}) do
    Enum.sum(for b <- open_bids(team),
             do: calculate_max_bid_vs_hidden_high_bid(b.bid_amount, b.hidden_high_bid))
  end

  @doc """
  Returns the number of dollars the team has spent

  """

  def team_dollars_spent(team = %Team{}) do
    rostered_players =
    team
    |> Ecto.assoc(:rostered_players)
    |> Repo.all
    Enum.sum(for p <- rostered_players, do: p.cost)
  end

  @doc """
  Returns the number of dollars the team has left to bid (not including hidden)

  """

  def team_dollars_remaining_for_bids(team = %Team{}) do
    auction = get_auction_by_id!(team.auction_id)
    team_dollars_remaining_for_bids(auction, team)
  end

  def team_dollars_remaining_for_bids(auction = %Auction{}, team = %Team{}) do
    dollars_left = dollars_per_team(auction) \
                    - (team_dollars_spent(team) + team_dollars_bid(team))
    if auction.must_roster_all_players do
      dollars_left - (auction.players_per_team \
                      - number_of_rostered_players_in_team(team) \
                      - number_of_bids_for_team(team))
    else
      dollars_left
    end
  end

  @doc """
  Returns the number of dollars the team has left to bid (including hidden)

  """

  def team_dollars_remaining_for_bids_including_hidden(team = %Team{}) do
    auction = get_auction_by_id!(team.auction_id)
    team_dollars_remaining_for_bids_including_hidden(auction, team)
  end

  def team_dollars_remaining_for_bids_including_hidden(auction = %Auction{}, team = %Team{}) do
    dollars_left = dollars_per_team(auction) \
                    - (team_dollars_spent(team) + team_dollars_bid_including_hidden(team))
    if auction.must_roster_all_players do
      dollars_left - (auction.players_per_team \
                      - number_of_rostered_players_in_team(team) \
                      - number_of_bids_for_team(team))
    else
      dollars_left
    end
  end

  @doc """
  Returns true if the team has enough money left for the bid amount, the "keep bidding up to" amount, and the hidden high bid

  """

  def legal_team_bid_amount?(auction = %Auction{}, team = %Team{}, args, existing_team_bid) do
    max_new_dollars = calculate_max_new_dollars(args, existing_team_bid)
    (team_dollars_remaining_for_bids_including_hidden(auction, team) - max_new_dollars) >= 0
  end

  defp calculate_max_new_dollars(args, nil) do
    calculate_max_bid(args[:bid_amount], args[:keep_bidding_up_to], args[:hidden_high_bid])
  end

  defp calculate_max_new_dollars(args, existing_team_bid) do
    max_existing = calculate_max_bid_vs_hidden_high_bid(existing_team_bid.bid_amount, existing_team_bid.hidden_high_bid)
    max_bid = calculate_max_bid_vs_hidden_high_bid(args[:bid_amount], args[:hidden_high_bid])
    max_bid - max_existing
  end

  defp calculate_max_bid_vs_hidden_high_bid(bid, nil) do
    bid
  end

  defp calculate_max_bid_vs_hidden_high_bid(bid, hidden_high_bid) do
    max(bid, hidden_high_bid)
  end

  defp calculate_max_bid(bid, nil, nil) do
    bid
  end

  defp calculate_max_bid(bid, keep_bidding_up_to, nil) do
    max(bid, keep_bidding_up_to)
  end

  defp calculate_max_bid(bid, nil, hidden_high_bid) do
    max(bid, hidden_high_bid)
  end

  defp calculate_max_bid(bid, keep_bidding_up_to, hidden_high_bid) do
    max(max(bid, keep_bidding_up_to), hidden_high_bid)
  end

  @doc """
  Starts the auction

  """
  def start_auction(auction = %Auction{}) do
    {:ok, now} = DateTime.now("Etc/UTC")
    now = now
      |> DateTime.truncate(:second)
      |> DateTime.add(-now.second, :second)

    update_bids_to_new_start_time(auction, now)

    auction
    |> Auction.active_changeset(%{active: true,
                                  started_or_paused_at: now})
    |> Repo.update()
  end

  defp update_bids_to_new_start_time(%Auction{} = auction, new_start_time) do
    seconds_since_auction_paused = DateTime.diff(new_start_time, auction.started_or_paused_at)
    Enum.map(Repo.preload(auction, [:bids]).bids,
             fn (bid) -> add_seconds_to_expires_at(seconds_since_auction_paused, bid) end)
  end

  defp add_seconds_to_expires_at(seconds, %Bid{} = bid) do
    bid
    |> Bid.changeset(%{expires_at: DateTime.add(bid.expires_at, seconds, :second)})
    |> Repo.update()
  end

  @doc """
  Pauses the auction

  """
  def pause_auction(auction = %Auction{}) do
    {:ok, now} = DateTime.now("Etc/UTC")
    now = now
      |> DateTime.truncate(:second)
      |> DateTime.add(-now.second, :second)

    auction
    |> Auction.active_changeset(%{active: false,
                                  started_or_paused_at: now})
    |> Repo.update()
  end

  @doc """
  Changes an auction name and/or nominations_per_team value

  """
  def change_auction_info(auction = %Auction{}, info) do
    auction
    |> Auction.changeset(Map.take(info, [:name, :nominations_per_team]))
    |> Repo.update()
    SingleAuction.publish_auction_status_change(auction)
  end

  @doc """
  Changes a team name and/or new_nominations_open_at date/time

  """
  def change_team_info(team = %Team{}, info) do
    team
    |> Team.changeset(Map.take(info, [:name, :new_nominations_open_at]))
    |> Repo.update()
    publish_team_info_change(team.id)
  end

 @doc """
  Changes a bid's expires_at time

  """
  def change_bid_info(bid = %Bid{}, info) do
    auction = get_auction_by_id!(info[:auction_id])
    expires_at = auction.started_or_paused_at
      |> DateTime.add(info[:seconds_before_expires], :second)
    bid
    |> Bid.changeset(%{expires_at: expires_at})
    |> Repo.update()
    SingleAuction.publish_bid_change(auction, get_team_by_id!(bid.team_id))
  end

  @doc """
  Adds the player to the team's nomination queue

  """

  def add_to_nomination_queue(player = %Player{}, team = %Team{}) do
    ordered_player =
      %OrderedPlayer{
        rank: largest_rank_in_team_nomination_queue(team) + 1,
        player: player
      }
    ordered_player = Ecto.build_assoc(team, :ordered_players, ordered_player)
    map = Repo.insert!(ordered_player)
    SingleAuction.publish_nomination_queue_change(team)
    SingleAuction.publish_queueable_players_change(team)
    map
  end

  defp find_ordered_player(player = %Player{}, team = %Team{}) do
    Repo.one(from op in OrderedPlayer,
             where: op.team_id == ^team.id and op.player_id == ^player.id)
  end

  defp find_ordered_player(player = %Player{}, auction = %Auction{}) do
    Repo.one(from op in OrderedPlayer,
             where: op.auction_id == ^auction.id and op.player_id == ^player.id)
  end

  defp find_ordered_player_by_rank(auction = %Auction{}, rank) do
    Repo.one(from op in OrderedPlayer,
             where: op.auction_id == ^auction.id and op.rank == ^rank)
  end

  def remove_from_nomination_queues(player = %Player{}, auction = %Auction{}) do
    remove_from_nomination_queue(player, auction)
    for team <- list_teams(auction) do
      remove_from_nomination_queue(player, team)
    end
  end

  def remove_from_nomination_queue(player = %Player{}, team = %Team{}) do
    ordered_player = find_ordered_player(player, team)
    if ordered_player != nil do
      ordered_player
      |> Ecto.Changeset.change
      |> Repo.delete
    end
  end

  def remove_from_nomination_queue(player = %Player{}, auction = %Auction{}) do
    ordered_player = find_ordered_player(player, auction)
    if ordered_player != nil do
      ordered_player
      |> Ecto.Changeset.change
      |> Repo.delete
    end
  end

  @doc """
  Logs a bid

  """
  def log_bid(bid = %Bid{}, auction = %Auction{}, team = %Team{}, player = %Player{}, type) do
    {:ok, now} = DateTime.now("Etc/UTC")
    %BidLog{}
    |> BidLog.changeset(%{amount: bid.bid_amount,
                          type: type,
                          datetime: now})
    |> Ecto.Changeset.put_assoc(:auction, auction)
    |> Ecto.Changeset.put_assoc(:team, team)
    |> Ecto.Changeset.put_assoc(:player, player)
    |> Repo.insert()
    # SingleAuction.publish_player_change(auction, player) <- TODO: create this
  end

  @doc """
  Submits a new bid

  """
  def submit_new_bid(auction = %Auction{}, team = %Team{}, player = %Player{}, attrs) do
    insert = %Bid{}
    |> Bid.changeset(Map.put(attrs, :nominated_by, team.id))
    |> Ecto.Changeset.put_assoc(:auction, auction)
    |> Ecto.Changeset.put_assoc(:team, team)
    |> Ecto.Changeset.put_assoc(:player, player)
    |> Repo.insert()
    case insert do
      {:ok, bid} ->
        log_bid(bid, auction, team, player, "N")
    end
    insert
  end

  @doc """
  Updates an existing bid

  """
  def update_existing_bid(bid, new_team = %Team{}, attrs) do
    update = bid
    |> Repo.preload([:team, :auction, :player])
    |> Bid.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:team, new_team)
    |> Repo.update()
    case update do
      {:ok, bid} ->
        log_bid(bid, bid.auction, bid.team, bid.player, "B")
    end
    update
  end

  @doc """
  Updates the bid amount of an existing bid

  """
  def update_existing_bid_amount(bid, bid_amount, bidding_team) do
    update = bid
    |> Repo.preload([:team, :auction, :player])
    |> Bid.changeset(%{bid_amount: bid_amount})
    |> Repo.update()
    case update do
      {:ok, bid} ->
        log_bid(bid, bid.auction, bid.team, bid.player, "H")
        log_bid(bid, bid.auction, bidding_team, bid.player, "U")
    end
    update
  end

  @doc """
  Returns a list of bid_logs (sorted by datetime) associated with the player

  """
  def bid_logs_for_player(player = %Player{}) do
    Repo.all(from bl in BidLog, where: bl.player_id == ^player.id, order_by: bl.datetime)
  end

  @doc """
  Returns a RosteredPlayer associated with the player, if there is one

  """
  def player_rostered(player = %Player{}) do
    Repo.one(from rp in RosteredPlayer, join: p in assoc(rp, :player), where: p.id == ^player.id)
  end

  # Dataloader - TODO: there are more functions in ~/dev/pragstudio-unpacked-graphql-code/backend/lib/getaways/vacation.ex

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end

end
