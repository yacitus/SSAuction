defmodule Ssauction.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string

    many_to_many :auctions, Ssauction.Auction, join_through: "auctions_teams"
    many_to_many :users, Ssauction.User, join_through: "teams_users"
  end

  def changeset(team, params \\ %{}) do
    required_fields = [:name]

    team
    |> cast(params, required_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
