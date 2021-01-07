defmodule Ssauction.BidLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bid_logs" do
    field :amount, :integer, null: false
    field :type, :string, null: false
    field :datetime, :utc_datetime, null: false

    belongs_to :auction, Ssauction.Auction
    belongs_to :team, Ssauction.Team
    belongs_to :player, Ssauction.Player

    timestamps()
  end

  def changeset(bid_log, params \\ %{}) do
    required_fields = [:amount, :type, :datetime]

    bid_log
    |> cast(params, required_fields)
    |> validate_required(required_fields)
    |> validate_inclusion(:type, ["N", "B", "U", "H", "R"]) # N - nomination; B - bid; U - bid under hidden high bid; H - hidden high bid; R - rostered
  end
end
