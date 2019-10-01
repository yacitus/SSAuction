defmodule SsauctionWeb.Resolvers.Accounts do
  alias Ssauction.Accounts
  alias Ssauction.SingleAuction

  def signin(_, %{username: username, password: password}, _) do
    case Accounts.authenticate(username, password) do
      :error ->
        {:error, "Invalid credentials"}

      {:ok, user} ->
        token = SsauctionWeb.AuthToken.sign(user)
        {:ok, %{user: user, token: token}}
    end
  end

  def user(_, %{id: id}, _) do
    {:ok, Accounts.get_user_by_id!(id)}
  end

  def me(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def me(_, _, _) do
    {:ok, nil}
  end

  def me_auction_admin(_, %{auction_id: auction_id}, %{context: %{current_user: user}}) do
    auction = SingleAuction.get_auction_by_id!(auction_id)
    {:ok, SingleAuction.user_is_auction_admin?(user, auction)}
  end

  def me_in_team(_, %{team_id: team_id}, %{context: %{current_user: user}}) do
    team = SingleAuction.get_team_by_id!(team_id)
    {:ok, SingleAuction.user_is_team_member?(user, team)}
  end

  def me_in_team(_, _, _) do
    {:ok, false}
  end
end
