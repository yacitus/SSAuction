defmodule Ssauction.Bid do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bids" do
    field :bid_amount, :integer
    field :hidden_high_bid, :integer
    field :expires_at, :utc_datetime

    has_one :player, Ssauction.Player
    belongs_to :team, Ssauction.Team
    belongs_to :auction, Ssauction.Auction
  end

  def changeset(bid, params \\ %{}) do
    required_fields = [:bid_amount, :expires_at, :player]
    optional_fields = [:hidden_high_bid]

    bid
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
