defmodule Ssauction.SingleAuction do
  @moduledoc """
  The SingleAuction context: public interface for working with a single auction
  """

  import Ecto.Query, warn: false
  alias Ssauction.Repo

  alias Ssauction.{Auction, Team, Player, Bid, OrderedPlayer, RosteredPlayer}
  alias Ssauction.User

  @doc """
  Returns all auctions.

  Raises `Ecto.NoResultsError` if no auction was found.
  """
  def get_all_auctions() do
    Repo.all(Auction)
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
  Returns a query of all players in an auction's bids

  """
  def players_in_auction_bids_query(auction = %Auction{}) do
    from a in Auction,
      where: a.id == ^auction.id,
      join: bids in assoc(a, :bids),
      join: player in assoc(bids, :player),
      select: player
  end

  @doc """
  Returns a query of all players rostered in an auction

  """
  def players_rostered_in_auction_query(auction = %Auction{}) do
    from a in Auction,
      where: a.id == ^auction.id,
      join: rostered_players in assoc(a, :rostered_players),
      join: player in assoc(rostered_players, :player),
      select: player
  end

  @doc """
  Returns a query of all players in an auction

  """
  def players_in_auction_query(auction = %Auction{}) do
    from player in Player,
      where: player.year_range == ^auction.year_range,
      select: player
  end

  @doc """
  Returns a query of all players in a team's nomination queue

  """
  def players_in_team_nomination_queue_query(team = %Team{}) do
    from t in Team,
      where: t.id == ^team.id,
      join: ordered_players in assoc(t, :ordered_players),
      join: player in assoc(ordered_players, :player),
      select: player
  end

  @doc """
  Returns a list of players who can be added to a team's nomination queue

  """
  def queueable_players(team = %Team{}) do
    auction = get_auction_by_id!(team.auction_id)

    bid_players = players_in_auction_bids_query(auction)
    rostered_players = players_rostered_in_auction_query(auction)
    queued_players = players_in_team_nomination_queue_query(team)

    queueable_players = from player in Player,
                          where: player.year_range == ^auction.year_range,
                          select: player,
                          except_all: ^bid_players,
                          except_all: ^rostered_players,
                          except_all: ^queued_players

    Repo.all(from p in subquery(queueable_players), order_by: p.id)
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
        # TODO - is there a way to make this more effecient with a query and/or dataloader
        Enum.member?(Repo.preload(auction, [:admins]).admins, user)
    end
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
    dollars_left - \
      (auction.players_per_team \
       - number_of_rostered_players_in_team(team) \
       - number_of_bids_for_team(team) \
       - 1) # the -1 is because a bid would remove the need to save a dollar for that one player
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
    |> Auction.active_changeset(%{active: true})
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
  Submits a new bid

  """
  def submit_new_bid(auction = %Auction{}, team = %Team{}, player = %Player{}, attrs) do
    %Bid{}
    |> Bid.changeset(attrs)
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