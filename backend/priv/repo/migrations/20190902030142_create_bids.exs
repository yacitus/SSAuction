defmodule Ssauction.Repo.Migrations.CreateBids do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :bid_amount, :integer, null: false
      add :hidden_high_bid, :integer
      add :time_of_bid, :utc_datetime, null: false

      add :team_id, references(:teams)
      add :auction_id, references(:auctions)
    end
  end
end
