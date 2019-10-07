defmodule Ssauction.Repo.Migrations.AlterBids do
  use Ecto.Migration

  def change do
    alter table(:bids) do
      add :closed, :boolean, null: false
    end
  end
end
