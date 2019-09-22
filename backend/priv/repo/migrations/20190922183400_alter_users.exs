defmodule Ssauction.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slack_display_name, :string, null: false
    end
  end
end
