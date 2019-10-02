defmodule SsauctionWeb.Schema.Middleware.AuthorizeUserAuctionAdmin do
  @behaviour Absinthe.Middleware

  alias Ssauction.SingleAuction

  def call(resolution, _) do
    case resolution.context do
      %{current_user: user} ->
        auction = SingleAuction.get_auction_by_id!(resolution.arguments.auction_id)
        case SingleAuction.user_is_auction_admin?(user, auction) do
          true ->
            resolution
          _ ->
            resolution
            |> Absinthe.Resolution.put_result({:error, "user not auction admin"})
        end

      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "No user signed in"})
    end
  end
end
