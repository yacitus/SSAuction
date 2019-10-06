defmodule Ssauction.Auction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auctions" do
    field :name, :string
    field :year_range, :string
    field :nominations_per_team, :integer, default: 2
    field :seconds_before_autonomination, :integer, default: 60*60*24
    field :bid_timeout_seconds, :integer, default: 60*60*12
    field :players_per_team, :integer
    field :team_dollars_per_player, :integer
    field :active, :boolean, default: false
    field :started_or_paused_at, :utc_datetime

    has_many :teams, Ssauction.Team
    has_many :bids, Ssauction.Bid
    has_many :rostered_players, Ssauction.RosteredPlayer
    has_many :ordered_players, Ssauction.OrderedPlayer

    many_to_many :admins, Ssauction.User, join_through: "auctions_users"

    timestamps()
  end

  def changeset(auction, params \\ %{}) do
    required_fields = [:name, :year_range, :nominations_per_team,
                       :bid_timeout_seconds, :seconds_before_autonomination,
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

  def active_changeset(auction, attrs) do
    current_active_state = auction.active

    auction
    |> cast(attrs, [:active, :started_or_paused_at])
    |> validate_required([:active, :started_or_paused_at])
    |> validate_active_changed(current_active_state)
  end

  defp validate_active_changed(changeset, current_active_state) do
    case {get_field(changeset, :active), current_active_state} do
      {false, false} ->
        add_error(changeset, :active, "auction already paused")
      {true, true} ->
        add_error(changeset, :active, "auction already running")
      {_, _} ->
        changeset
    end
  end
end
