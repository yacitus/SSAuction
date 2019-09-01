defmodule Ssauction.Repo.Migrations.CreateAuctionsUsers do
  use Ecto.Migration

  def change do
    create table(:auctions_users) do
      add :auction_id, references(:auctions)
      add :user_id, references(:users)
    end

    create unique_index(:auctions_users, [:auction_id, :user_id])
  end
end
