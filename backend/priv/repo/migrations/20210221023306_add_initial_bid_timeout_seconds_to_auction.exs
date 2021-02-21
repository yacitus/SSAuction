defmodule Ssauction.Repo.Migrations.AddInitialBidTimeoutSecondsToAuction do
  use Ecto.Migration

  def change do
    alter table(:auctions) do
      add :initial_bid_timeout_seconds, :integer, default: 60*60*24
    end
  end
end
