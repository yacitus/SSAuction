defmodule Ssauction.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :unused_nominations, :integer, default: 2
    field :time_of_last_nomination, :utc_datetime

    belongs_to :auction, Ssauction.Auction

    has_many :bids, Ssauction.Bid, on_replace: :nilify
    has_many :rostered_players, Ssauction.RosteredPlayer
    has_many :ordered_players, Ssauction.OrderedPlayer

    many_to_many :users, Ssauction.User, join_through: "teams_users"
  end

  def changeset(team, params \\ %{}) do
    required_fields = [:name, :unused_nominations]
    optional_fields = [:time_of_last_nomination]

    team
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
