defmodule Ssauction.Repo.Migrations.CreateAuctionsTeams do
  use Ecto.Migration

  def change do
    create table(:auctions_teams) do
      add :auction_id, references(:auctions)
      add :team_id, references(:teams)
    end

    create unique_index(:auctions_teams, [:auction_id, :team_id])
  end
end
