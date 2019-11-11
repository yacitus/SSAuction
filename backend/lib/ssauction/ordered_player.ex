defmodule Ssauction.OrderedPlayer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ordered_players" do
    field :rank, :integer

    belongs_to :player, Ssauction.Player
    belongs_to :team, Ssauction.Team
    belongs_to :auction, Ssauction.Auction
  end

  def changeset(rostered_player, params \\ %{}) do
    required_fields = [:rank]

    rostered_player
    |> cast(params, required_fields)
    |> validate_required(required_fields)
  end
end
