defmodule SsauctionWeb.Schema.Middleware.AuthorizeUserInTeam do
  @behaviour Absinthe.Middleware

  alias Ssauction.SingleAuction
  alias Ssauction.{ Team, Bid }

  def call(resolution, _) do
    team = case resolution.source do
             %Team{} ->
               resolution.source
             %Bid{} ->
               IO.inspect resolution.source.team_id, label: "AuthorizeUserInTeam resolution.source.team_id"
               SingleAuction.get_team_by_id!(resolution.source.team_id)
             _ ->
               SingleAuction.get_team_by_id!(resolution.arguments.team_id)
           end

    case resolution.context do
      %{current_user: user} ->
        case SingleAuction.user_is_team_member?(user, team) do
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
