defmodule Ssauction.Repo do
  use Ecto.Repo, otp_app: :ssauction, adapter: Ecto.Adapters.Postgres
  alias Ssauction.AllPlayer

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def import_all_players_from_csv_file(csv_filepath, year_range) do
    csv_filepath
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn [ssnum, name, position] ->
        AllPlayer.changeset(%AllPlayer{},
                            %{year_range: year_range,
                              ssnum: ssnum,
                              name: name,
                              position: position})
        |> insert!(on_conflict: :nothing)
       end)
  end
end
