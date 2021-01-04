defmodule Ssauction.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :unused_nominations, :integer, default: 0
    field :time_nominations_expire, :utc_datetime
    field :new_nominations_open_at, :utc_datetime

    belongs_to :auction, Ssauction.Auction

    has_many :bids, Ssauction.Bid, on_replace: :nilify
    has_many :rostered_players, Ssauction.RosteredPlayer
    has_many :ordered_players, Ssauction.OrderedPlayer
    has_many :bid_logs, Ssauction.BidLog

    many_to_many :users, Ssauction.User, join_through: "teams_users"
  end

  def changeset(team, params \\ %{}) do
    required_fields = [:name, :unused_nominations, :new_nominations_open_at]
    optional_fields = [:time_nominations_expire]

    team
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
