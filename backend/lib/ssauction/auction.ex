defmodule Ssauction.Auction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auctions" do
    field :name, :string
    field :year_range, :string
    field :bid_timeout_seconds, :integer, default: 60*12
    field :players_per_team, :integer
    field :team_dollars_per_player, :integer
    field :active, :boolean, default: false
    field :started_or_paused_at, :utc_datetime

    has_many :teams, Ssauction.Team
    has_many :bids, Ssauction.Bid

    many_to_many :admins, Ssauction.User, join_through: "auctions_users"

    timestamps()
  end

  def changeset(auction, params \\ %{}) do
    required_fields = [:name, :year_range, :bid_timeout_seconds,
                       :players_per_team, :team_dollars_per_player, :active]
    optional_fields = [:started_or_paused_at]

    auction
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
    |> validate_number(:players_per_team, greater_than: 0)
    |> validate_number(:team_dollars_per_player, greater_than_or_equal_to: 10)
    |> Ssauction.Player.validate_year_range()
  end
end
