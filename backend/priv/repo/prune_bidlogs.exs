# Script for pruning duplicate bid log rows
#
# Run it with:
#
#     mix run priv/repo/prune_bidlogs.exs

import Ecto.Query, warn: false
import Ecto.Changeset

alias Ssauction.Repo
# alias Ssauction.User
# alias Ssauction.AllPlayer
alias Ssauction.Player
alias Ssauction.Team
alias Ssauction.Auction
# alias Ssauction.Bid
alias Ssauction.RosteredPlayer
# alias Ssauction.OrderedPlayer
# alias Ssauction.SingleAuction
alias Ssauction.BidLog

defmodule PruneBidlogs do
  def prune_if(logs) do
    l1 = hd(logs)
    l2 = hd(tl(logs))
    if l1.amount == l2.amount && l1.team_id == l2.team_id do
      IO.puts("duplicate #{l1.amount}")
      Repo.delete!(l1)
    end

    if Enum.count(tl(logs)) > 1 do
      prune_if(tl(logs))
    end
    :ok
  end

  def prune_player_bidlog(rostered_player) do
    logs = Repo.all(from bl in BidLog, where: bl.player_id == ^rostered_player.player.id, order_by: :id)
    IO.puts("player: #{rostered_player.player.id} #{rostered_player.player.name}")
    num_logs = Enum.count(logs)
    IO.puts("  #{num_logs} log rows")
    if num_logs > 1 do
      prune_if(logs)
    end
    :ok
  end

  def prune_bidlogs do
    auction_id = 3

    rostered_players = Repo.all(from rp in RosteredPlayer, where: rp.auction_id == ^auction_id, preload: :player)

    Enum.map(rostered_players, &prune_player_bidlog/1)

    :ok
  end
end

PruneBidlogs.prune_bidlogs
