defmodule Ssauction.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :dollars_spent, :integer, null: false
      add :dollars_bid, :integer, null: false
      add :unused_nominations, :integer, null: false
      add :time_nominations_expire, :utc_datetime
      add :new_nominations_open_at, :utc_datetime # only used if auction.new_nominations_created == "time"

      add :auction_id, references(:auctions)
    end

    create unique_index(:teams, [:name])
  end
end
