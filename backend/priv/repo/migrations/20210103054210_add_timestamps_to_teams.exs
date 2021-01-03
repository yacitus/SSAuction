defmodule Ssauction.Repo.Migrations.AddTimestampsToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      timestamps default: "2021-01-01 00:00:01", null: false
    end
  end
end
