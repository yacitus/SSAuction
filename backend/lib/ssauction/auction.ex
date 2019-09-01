defmodule Ssauction.Auction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auctions" do
    field :name, :string
    field :active, :boolean, default: false
    field :players_per_team, :integer
    field :team_dollars_per_player, :integer

    many_to_many :teams, Ssauction.Team, join_through: "auctions_teams"
    many_to_many :admins, Ssauction.User, join_through: "auctions_users"

    timestamps()
  end

  def changeset(auction, params \\ %{}) do
    required_fields = [:name, :players_per_team, :team_dollars_per_player]
    optional_fields = [:active]

    auction
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
    |> validate_number(:players_per_team, greater_than: 0)
    |> validate_number(:team_dollars_per_player, greater_than_or_equal_to: 10)
  end
end
