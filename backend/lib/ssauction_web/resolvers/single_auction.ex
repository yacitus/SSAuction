defmodule SsauctionWeb.Resolvers.SingleAuction do
  alias Ssauction.SingleAuction

  def auction(_, %{id: id}, _) do
    {:ok, SingleAuction.get_auction_by_id!(id)}
  end

  def auctions(_, _, _) do
    {:ok, SingleAuction.get_all_auctions()}
  end
end
