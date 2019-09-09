defmodule Ssauction.Bid do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bids" do
    field :bid_amount, :integer
    field :hidden_high_bid, :integer
    field :expires_at, :utc_datetime

    has_one :player, Ssauction.Player
    belongs_to :team, Ssauction.Team, on_replace: :nilify
    belongs_to :auction, Ssauction.Auction
  end

  def changeset(bid, params \\ %{}) do
    required_fields = [:bid_amount, :expires_at]
    optional_fields = [:hidden_high_bid, :team_id]

    bid
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> assoc_constraint(:team)
    |> assoc_constraint(:auction)
  end
end
