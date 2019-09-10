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
end
