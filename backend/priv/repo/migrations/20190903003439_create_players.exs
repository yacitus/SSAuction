defmodule Ssauction.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :year_range, :string, null: false
      add :ssnum, :integer, null: false
      add :name, :string, null: false
      add :position, :string, null: false

      add :bid_id, references(:bids)
      add :rostered_player_id, references(:rostered_players)
      add :ordered_player_id, references(:ordered_players)
    end

    create unique_index(:players, [:year_range, :ssnum])
  end
end
