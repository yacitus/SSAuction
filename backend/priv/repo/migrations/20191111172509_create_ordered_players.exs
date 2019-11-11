defmodule Ssauction.Repo.Migrations.CreateOrderedPlayers do
  use Ecto.Migration

  def change do
    create table(:ordered_players) do
      add :rank, :integer, null: false

      add :player_id, references(:players)
      add :team_id, references(:teams)
      add :auction_id, references(:auctions)
    end
  end
end
