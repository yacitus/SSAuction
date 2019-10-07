defmodule Ssauction.Repo.Migrations.CreateBids do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :bid_amount, :integer, null: false
      add :hidden_high_bid, :integer
      add :expires_at, :utc_datetime, null: false
      add :nominated_by, :integer, null: false

      add :team_id, references(:teams)
      add :auction_id, references(:auctions)
    end
  end
end
