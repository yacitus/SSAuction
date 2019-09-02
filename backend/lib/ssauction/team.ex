defmodule Ssauction.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string

    belongs_to :auction, Ssauction.Auction

    has_many :bids, Ssauction.Bid

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
