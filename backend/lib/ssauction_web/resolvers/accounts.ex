defmodule SsauctionWeb.Resolvers.Accounts do
  alias Ssauction.Accounts

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
end
