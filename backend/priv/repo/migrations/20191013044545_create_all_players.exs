defmodule Ssauction.Repo.Migrations.CreateAllPlayers do
  use Ecto.Migration

  def change do
    create table(:all_players) do
      add :year_range, :string, null: false
      add :ssnum, :integer, null: false
      add :name, :string, null: false
      add :position, :string, null: false
    end

    create unique_index(:all_players, [:year_range, :ssnum])
  end
end
