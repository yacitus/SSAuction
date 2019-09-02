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

end
