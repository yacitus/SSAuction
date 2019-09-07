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
  def list_teams(%Auction{} = auction) do
    Repo.preload(auction, [:teams]).teams
  end

  @doc """
  Returns the team with the given `id`.

  Raises `Ecto.NoResultsError` if no auction was found.
  """
  def get_team_by_id!(id) do
    Repo.get!(Team, id)
  end

  @doc """
  Returns a list of bids for all teams in the auction

  """
  def get_bids_in_auction!(%Auction{} = auction) do
    Repo.all(from b in Bid, where: b.auction_id == ^auction.id)
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
  Starts the auction

  """
  def start_auction(%Auction{} = auction) do
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
  def pause_auction(%Auction{} = auction) do
    {:ok, utc_datetime} = DateTime.now("Etc/UTC")

    auction
    |> Auction.active_changeset(%{active: false,
                                  started_or_paused_at: utc_datetime})
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
