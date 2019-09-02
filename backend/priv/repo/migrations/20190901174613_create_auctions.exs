defmodule Ssauction.Repo.Migrations.CreateAuctions do
  use Ecto.Migration

  def change do
    create table(:auctions) do
      add :name, :string, null: false
      add :year_range, :string, null: false
      add :nominations_per_team, :integer, null: false
      add :bid_timeout_seconds, :integer, null: false
      add :active, :boolean, null: false
      add :players_per_team, :integer, null: false
      add :team_dollars_per_player, :integer, null: false
      add :started_or_paused_at, :utc_datetime

      timestamps()
    end

    create unique_index(:auctions, [:name])
  end
end
