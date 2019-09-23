defmodule SsauctionWeb.Schema.Middleware.AuthorizeUserInTeam do
  @behaviour Absinthe.Middleware

  alias Ssauction.SingleAuction

  def call(resolution, _) do
    IO.inspect resolution.source, label: "AuthorizeUserInTeam resolution.source: "
    case resolution.context do
      %{current_user: user} ->
        case SingleAuction.user_is_team_member?(user, resolution.source) do
          true ->
            resolution
          _ ->
            resolution
            |> Absinthe.Resolution.put_result({:error, "user not team member"})
        end

      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "No user signed in"})
    end
  end
end
