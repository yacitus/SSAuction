defmodule Ssauction.Repo.Migrations.CreateBidLogs do
  use Ecto.Migration
  alias Ssauction.RosteredPlayer
  alias Ssauction.Repo
  alias Ssauction.Auction
  alias Ssauction.BidLog
  alias Ssauction.Team
  alias Ssauction.Player

  def up do
    create table(:bid_logs) do
      add :amount, :integer, null: false
      add :type, :string, null: false
      add :datetime, :utc_datetime, null: false

      add :auction_id, references(:auctions)
      add :team_id, references(:teams)
      add :player_id, references(:players)

      timestamps()
    end

    flush()

    Repo.all(RosteredPlayer)
    |> Enum.each(fn rp ->
                   rp = Repo.preload(rp, [:player])
                   auction = Repo.get!(Auction, rp.auction_id)
                   %BidLog{}
                   |> BidLog.changeset(%{amount: rp.cost,
                                         type: "R",
                                         datetime: auction.started_or_paused_at})
                   |> Ecto.Changeset.put_assoc(:auction, auction)
                   |> Ecto.Changeset.put_assoc(:team, Repo.get!(Team, rp.team_id))
                   |> Ecto.Changeset.put_assoc(:player, rp.player)
                   |> Repo.insert()
                 end)
  end

  def down do
    drop table("bid_logs")
  end
end
