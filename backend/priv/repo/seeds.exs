# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ssauction.Repo.insert!(%Ssauction.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto.Query, warn: false

alias Ssauction.Repo
alias Ssauction.User
alias Ssauction.AllPlayer
alias Ssauction.Player
alias Ssauction.Team
alias Ssauction.Auction
# alias Ssauction.Bid
alias Ssauction.RosteredPlayer
alias Ssauction.OrderedPlayer
alias Ssauction.SingleAuction

#
# ALL PLAYERS
#

# year_range = "1985-1988-NL"

# "1985-1988-NL_players.csv"
# |> Path.expand(__DIR__)
# |> File.read!()
# |> String.split("\n", trim: true)
# |> Enum.map(&String.split(&1, ","))
# |> Enum.map(fn [ssnum, name, position] ->
#      %AllPlayer{}
#      |> AllPlayer.changeset(%{
#           year_range: year_range,
#           name: name,
#           ssnum: ssnum,
#           position: String.trim_trailing(position)
#         })
#      |> Repo.insert!
#    end)


year_range = "1988-1991-SL"

"1988-1991-SL_players.csv"
|> Path.expand(__DIR__)
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(&String.split(&1, ","))
|> Enum.map(fn [ssnum, name, position] ->
     %AllPlayer{}
     |> AllPlayer.changeset(%{
          year_range: year_range,
          name: name,
          ssnum: ssnum,
          position: String.trim_trailing(position)
        })
     |> Repo.insert!
   end)

# year_range = "2020-2020-BL"

# "2020-2020-BL_players.csv"
# |> Path.expand(__DIR__)
# |> File.read!()
# |> String.split("\n", trim: true)
# |> Enum.map(&String.split(&1, ","))
# |> Enum.map(fn [ssnum, name, position] ->
#      %AllPlayer{}
#      |> AllPlayer.changeset(%{
#           year_range: year_range,
#           name: name,
#           ssnum: ssnum,
#           position: String.trim_trailing(position)
#         })
#      |> Repo.insert!
#    end)

#
# 1985-1988-NL AUCTION
#


# {:ok, now} = DateTime.now("Etc/UTC")
# now = DateTime.truncate(now, :second)

# year_range = "1985-1988-NL"

# auction_1985_1988_NL = SingleAuction.create_auction(name: "Test Auction: 1985-1988-NL",
#                                        year_range: year_range,
#                                        players_per_team: 10,
#                                        team_dollars_per_player: 10,
#                                        bid_timeout_seconds: 2*60,
#                                        started_or_paused_at: now)

#
# PLAYERS FROM AUCTION
#

# player1 = Repo.get!(Player, 1)
# player2 = Repo.get!(Player, 2)
# player3 = Repo.get!(Player, 3)
# player4 = Repo.get!(Player, 4)

#
# 1988-1991-BL AUCTION
#


{:ok, now} = DateTime.now("Etc/UTC")
now = DateTime.truncate(now, :second)

year_range = "1988-1991-SL"

auction_1988_1991_SL = SingleAuction.create_auction(name: "Test Auction: 1988-1991-SL",
                                                    year_range: year_range,
                                                    nominations_per_team: 2,
                                                    seconds_before_autonomination: 60*60,
                                                    new_nominations_created: "time",
                                                    bid_timeout_seconds: 60*60*12,
                                                    players_per_team: 50,
                                                    must_roster_all_players: false,
                                                    team_dollars_per_player: 20,
                                                    started_or_paused_at: now)

#
# USERS
#

daryl =
  %User{}
  |> User.changeset(%{
      username: "daryl",
      email: "daryl.spitzer@gmail.com",
      slack_display_name: "daryl",
      super: true,
      password: "CxKtzVJ"
    })
  |> Repo.insert!

tom =
  %User{}
  |> User.changeset(%{
      username: "tom",
      email: "han60man@aol.com",
      slack_display_name: "han60man",
      password: "gnrPiTP"
    })
  |> Repo.insert!

#
# TEAMS (one team can't be in more than one auction yet)
#

team_daryl =
  %Team{
    name: "Team Daryl",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.add(now, 60*1, :second),
    } |> Repo.insert!

team_tom =
  %Team{
    name: "Team Tom",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.add(now, 60*10, :second),
    } |> Repo.insert!

# team_daryl2 =
#   %Team{
#     name: "Team Daryl (a2)",
#     } |> Repo.insert!

# team_tom2 =
#   %Team{
#     name: "Team Tom (a2)",
#     } |> Repo.insert!

#
# PUT USERS IN TEAMS
#

Repo.preload(team_daryl, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [daryl])
|> Repo.update!()

Repo.preload(team_tom, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [tom])
|> Repo.update!()

# Repo.preload(team_daryl2, [:users])
# |> Ecto.Changeset.change()
# |> Ecto.Changeset.put_assoc(:users, [daryl])
# |> Repo.update!()

# Repo.preload(team_tom2, [:users])
# |> Ecto.Changeset.change()
# |> Ecto.Changeset.put_assoc(:users, [tom])
# |> Repo.update!()

#
# PUT TEAMS IN AUCTIONS
#

Repo.preload(auction_1988_1991_SL, [:teams])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:teams, [team_daryl, team_tom])
|> Repo.update!()


# Repo.preload(auction_2020_BL, [:teams])
# |> Ecto.Changeset.change()
# |> Ecto.Changeset.put_assoc(:teams, [team_daryl, team_tom])
# |> Repo.update!()

#
# GIVE THE AUCTIONS AN ADMIN
#

Repo.preload(auction_1988_1991_SL, [:admins])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:admins, [daryl])
|> Repo.update!()

# Repo.preload(auction_2020_BL, [:admins])
# |> Ecto.Changeset.change()
# |> Ecto.Changeset.put_assoc(:admins, [daryl])
# |> Repo.update!()

#
# CREATE A BID
#

# bid_amount = 2
# {:ok, now} = DateTime.now("Etc/UTC")
# attrs = %{bid_amount: bid_amount,
#           expires_at: DateTime.add(now, auction.bid_timeout_seconds, :second),
#           # the below line is an alternative to the above for testing
#           # expires_at: DateTime.add(now, 10, :second),
#           player: player1}
# Ssauction.SingleAuction.submit_new_bid(auction, team_daryl, player1, attrs)

# Team.changeset(team_daryl, %{unused_nominations: team_daryl.unused_nominations-1,
#                              dollars_bid: team_daryl.dollars_bid + bid_amount,
#                              time_of_last_nomination: now})
# |> Repo.update!()

# Auction.changeset(auction, %{started_or_paused_at: now})
# |> Repo.update!()

#
# ROSTER A PLAYER
#

# player_cost = 4
# rostered_player =
#   %RosteredPlayer{
#     cost: player_cost,
#     player: player2
#   }
# rostered_player = Ecto.build_assoc(team_two, :rostered_players, rostered_player)
# rostered_player = Ecto.build_assoc(auction, :rostered_players, rostered_player)
# Repo.insert!(rostered_player)

# Team.changeset(team_two, %{dollars_spent: team_daryl.dollars_spent + player_cost})
# |> Repo.update!()

#
# ADD A PLAYER TO A TEAM'S NOMINATION LIST
#

# ordered_player =
#   %OrderedPlayer{
#     rank: 1,
#     player: player3
#   }
# ordered_player = Ecto.build_assoc(team_daryl, :ordered_players, ordered_player)
# Repo.insert!(ordered_player)

#
# ADD PLAYERS TO THE AUCTION'S AUTO-NOMINATION LIST
#

"1988-1991-SL_players_sorted_by_playing_time.csv"
|> Path.expand(__DIR__)
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(&String.split(&1, ","))
|> Enum.with_index(1)
|> Enum.map(fn {[_, ssnum, name], i} ->
    player = Repo.one!(from player in Player,
                        where: player.auction_id == ^auction_1988_1991_SL.id and player.ssnum == ^ssnum,
                        select: player)
    ordered_player =
      %OrderedPlayer{
        rank: i,
        player: player
      }
    ordered_player = Ecto.build_assoc(auction_1988_1991_SL, :ordered_players, ordered_player)
    Repo.insert!(ordered_player)
   end)
