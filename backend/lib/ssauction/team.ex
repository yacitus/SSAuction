defmodule Ssauction.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :dollars_spent, :integer, default: 0
    field :dollars_bid, :integer, default: 0

    belongs_to :auction, Ssauction.Auction

    has_many :bids, Ssauction.Bid
    has_many :rostered_players, Ssauction.RosteredPlayer

    many_to_many :users, Ssauction.User, join_through: "teams_users"
  end

  def changeset(team, params \\ %{}) do
    required_fields = [:name]
    optional_fields = [:dollars_spent, :dollars_bid]

    team
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
