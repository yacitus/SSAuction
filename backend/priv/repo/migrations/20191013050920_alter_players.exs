defmodule Ssauction.Repo.Migrations.AlterPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
	  add :auction_id, references(:auctions)
	end
  end
end
