defmodule Ssauction.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :dollars_spent, :integer, null: false
      add :dollars_bid, :integer, null: false
      add :unused_nominations, :integer, null: false
      add :time_of_last_nomination, :utc_datetime

      add :auction_id, references(:auctions)
    end

    create unique_index(:teams, [:name])
  end
end
