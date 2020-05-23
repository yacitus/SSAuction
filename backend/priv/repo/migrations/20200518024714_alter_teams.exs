defmodule Ssauction.Repo.Migrations.AlterTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      remove :dollars_spent
      remove :dollars_bid
    end
  end
end
