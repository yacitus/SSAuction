defmodule Ssauction.Repo.Migrations.CreateAuctions do
  use Ecto.Migration

  def change do
    create table(:auctions) do
      add :name, :string, null: false
      add :active, :boolean, null: false
      add :players_per_team, :integer, null: false
      add :team_dollars_per_player, :integer, null: false

      timestamps()
    end

    create unique_index(:auctions, [:name])
  end
end
