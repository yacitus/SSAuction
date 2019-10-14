defmodule Ssauction.SingleAuction do
  @moduledoc """
  The SingleAuction context: public interface for working with a single auction
  """

  import Ecto.Query, warn: false
  alias Ssauction.Repo

  alias Ssauction.{Auction, Team, AllPlayer, Player, Bid, OrderedPlayer, RosteredPlayer}
  alias Ssauction.User

  alias SsauctionWeb.Resolvers.SingleAuction

  @doc """
  Returns all auctions.

  Raises `Ecto.NoResultsError` if no auction was found.
  """
  def create_auction(name: name,
                     year_range: year_range,
                     players_per_team: players_per_team,
                     team_dollars_per_player: team_dollars_per_player) do
    auction =
      %Auction{
        name: name,
        year_range: year_range,
        players_per_team: players_per_team,
        team_dollars_per_player: team_dollars_per_player,
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
    team
    |> Team.changeset(%{dollars_spent: team.dollars_spent + bid.bid_amount,
                        dollars_bid: team.dollars_bid - bid.bid_amount})
    |> Repo.update
    player
    |> Ecto.Changeset.change(%{bid_id: nil})
    |> Repo.update
    bid
    |> Ecto.Changeset.change
    |> Repo.delete
    update_unused_nominations(nominating_team, auction)
    SingleAuction.publish_bid_change(auction, team)
    SingleAuction.publish_roster_change(auction, team)
    SingleAuction.publish_queueable_players_change(team)
    publish_team_info_change(team.id)
    publish_team_info_change(nominating_team.id)
  end

  @doc """
  Update a team's unused nominations after bidding closed on a nomination

  """
  defp update_unused_nominations(team = %Team{}, auction = %Auction{}) do
    team = Repo.get(Team, team.id)
    open_roster_spots = open_roster_spots(team, auction)
    new_unused_nominations = Enum.min([team.unused_nominations+1,
                                       open_roster_spots])
    team
    |> Team.changeset(%{unused_nominations: new_unused_nominations})
    |> Repo.update
  end

  @doc """
  Update a team's info after a nomination

  """
  def update_team_info_post_nomination(team = %Team{}, args) do
    {:ok, now} = DateTime.now("Etc/UTC")
    team
    |> Team.changeset(%{unused_nominations: team.unused_nominations-1,
                        dollars_bid: team.dollars_bid+args.bid_amount,
                        time_of_last_nomination: now})
    |> Repo.update
    publish_team_info_change(team.id)
  end

  @doc """
  Reload the team and publish that its info has changed

  """
  defp publish_team_info_change(team_id) do
    Repo.get(Team, team_id)
    |> SingleAuction.publish_team_info_change()
  end

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
  Returns a query of all players in thhe auction's bids

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
  Returns the number of dollars the team has left to bid

  """

  def team_dollars_remaining_for_bids(team = %Team{}) do
    auction = get_auction_by_id!(team.auction_id)
    team_dollars_remaining_for_bids(auction, team)
  end

  def team_dollars_remaining_for_bids(auction = %Auction{}, team = %Team{}) do
    dollars_left = dollars_per_team(auction) - (team.dollars_spent + team.dollars_bid)
    dollars_left - (auction.players_per_team \
                    - number_of_rostered_players_in_team(team) \
                    - number_of_bids_for_team(team))
  end

  @doc """
  Returns true if the team has enough money left for the bid amount (and hidden high bid)

  """

  def legal_team_bid_amount?(auction = %Auction{}, team = %Team{}, args, existing_team_bid) do
    max_new_dollars = calculate_max_new_dollars(args, existing_team_bid)
    (team_dollars_remaining_for_bids(auction, team) - max_new_dollars) >= 0
  end

  defp calculate_max_new_dollars(args, nil) do
    calculate_max_bid_vs_hidden_high_bid(args[:bid_amount], args[:hidden_high_bid])
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

  @doc """
  Starts the auction

  """
  def start_auction(auction = %Auction{}) do
    {:ok, utc_datetime} = DateTime.now("Etc/UTC")

    update_bids_to_new_start_time(auction, utc_datetime)

    auction
    |> Auction.active_changeset(%{active: true,
                                  started_or_paused_at: utc_datetime})
    |> Repo.update()
  end

  defp update_bids_to_new_start_time(%Auction{} = auction, new_start_time) do
    seconds_since_auction_paused = DateTime.diff(new_start_time, auction.started_or_paused_at)
    Enum.map(Repo.preload(auction, [:bids]).bids,
             fn (bid) -> add_seconds_to_expires_at(seconds_since_auction_paused, bid) end)
  end

  defp add_seconds_to_expires_at(seconds, %Bid{} = bid) do
    bid
    |> Bid.changeset(%{expires_at: DateTime.add(bid.expires_at, seconds)})
    |> Repo.update()
  end

  @doc """
  Pauses the auction

  """
  def pause_auction(auction = %Auction{}) do
    {:ok, utc_datetime} = DateTime.now("Etc/UTC")

    auction
    |> Auction.active_changeset(%{active: false,
                                  started_or_paused_at: utc_datetime})
    |> Repo.update()
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

  @doc """
  Removes the player from the team's nomination queue

  """

  defp find_ordered_player(player = %Player{}, team = %Team{}) do
    nomination_queue_query = from op in OrderedPlayer,
                               where: op.team_id == ^team.id,
                               preload: [:player]
    Repo.all(nomination_queue_query)
    |> Enum.find(fn ordered_player -> ordered_player.player.id == player.id end)
  end

  def remove_from_nomination_queue(player = %Player{}, team = %Team{}) do
    ordered_player = find_ordered_player(player, team)
    if ordered_player != nil do
      player
      |> Ecto.Changeset.change(%{ordered_player_id: nil})
      |> Repo.update
      ordered_player
      |> Ecto.Changeset.change
      |> Repo.delete
    end
  end

  @doc """
  Submits a new bid

  """
  def submit_new_bid(auction = %Auction{}, team = %Team{}, player = %Player{}, attrs) do
    %Bid{}
    |> Bid.changeset(Map.put(attrs, :nominated_by, team.id))
    |> Ecto.Changeset.put_assoc(:auction, auction)
    |> Ecto.Changeset.put_assoc(:team, team)
    |> Ecto.Changeset.put_assoc(:player, player)
    |> Repo.insert()
  end

  @doc """
  Updates an existing bid

  """
  def update_existing_bid(bid, new_team = %Team{}, attrs) do
    bid
    |> Repo.preload([:team])
    |> Bid.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:team, new_team)
    |> Repo.update()
  end


  # Dataloader - TODO: there are more functions in ~/dev/pragstudio-unpacked-graphql-code/backend/lib/getaways/vacation.ex

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end

end
3