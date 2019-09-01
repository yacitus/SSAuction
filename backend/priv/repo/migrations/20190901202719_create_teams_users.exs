defmodule Ssauction.Repo.Migrations.CreateTeamsUsers do
  use Ecto.Migration

  def change do
    create table(:teams_users) do
      add :team_id, references(:teams)
      add :user_id, references(:users)
    end

    create unique_index(:teams_users, [:team_id, :user_id])
  end
end
