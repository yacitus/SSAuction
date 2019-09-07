defmodule Ssauction.Accounts do
  @moduledoc """
  The Accounts context: public interface for account functionality.
  """

  import Ecto.Query, warn: false
  alias Ssauction.Repo

  alias Ssauction.User

  @doc """
  Returns the user with the given `id`.

  Returns `nil` if the user does not exist.
  """
  def get_user_by_id(id) do
    Repo.get(User, id)
  end

  # Dataloader

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end

end
