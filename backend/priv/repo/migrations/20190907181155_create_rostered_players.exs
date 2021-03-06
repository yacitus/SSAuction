defmodule Ssauction.Repo.Migrations.CreateRosteredPlayers do
  use Ecto.Migration

  def change do
    create table(:rostered_players) do
      add :cost, :integer, null: false

      add :team_id, references(:teams)
      add :auction_id, references(:auctions)
    end
  end
end
