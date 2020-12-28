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
# 1988-1991-BL AUCTION
#


{:ok, now} = DateTime.now("Etc/UTC")
now = now
  |> DateTime.truncate(:second)
  |> DateTime.add(-now.second, :second)

year_range = "1988-1991-SL"

auction_1988_1991_SL = SingleAuction.create_auction(name: "Inaugural: 1988-1991-SL",
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
      slack_display_name: "@daryl",
      super: true,
      password: "CxKtzVJ"
    })
  |> Repo.insert!

tom =
  %User{}
  |> User.changeset(%{
      username: "tom",
      email: "han60man@aol.com",
      slack_display_name: "@han60man",
      password: "gnrPiTP"
    })
  |> Repo.insert!

jerry =
  %User{}
  |> User.changeset(%{
      username: "jerry",
      email: "gvelli@comcast.net",
      slack_display_name: "@Jerry V",
      password: "CyssPnt"
    })
  |> Repo.insert!

joe =
  %User{}
  |> User.changeset(%{
      username: "joe",
      email: "joe@manycycles.com",
      slack_display_name: "@Joe Golton",
      password: "GxRashA"
    })
  |> Repo.insert!

john =
  %User{}
  |> User.changeset(%{
      username: "john",
      email: "johndjones44@yahoo.com",
      slack_display_name: "@johndjones44",
      password: "YsenMtt"
    })
  |> Repo.insert!

harry =
  %User{}
  |> User.changeset(%{
      username: "harry",
      email: "haguilera1021@gmail.com",
      slack_display_name: "@Harry",
      password: "UZegTYX"
    })
  |> Repo.insert!

george =
  %User{}
  |> User.changeset(%{
      username: "george",
      email: "gejoycejr@gmail.com",
      slack_display_name: "@George E Joyce Jr",
      password: "dYhpsPv"
    })
  |> Repo.insert!

#
# TEAMS (one team can't be in more than one auction yet)
#

{:ok, nomination_time} = DateTime.new(~D[2020-12-04], ~T[16:45:00.000], "Etc/UTC")
# nomination_time = DateTime.add(now, 60*2, :second)
team_daryl =
  %Team{
    name: "Team Daryl",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-12-04], ~T[12:00:00.000], "Etc/UTC")
team_tom =
  %Team{
    name: "Team Tom & Jerry",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-12-04], ~T[14:30:00.000], "Etc/UTC")
team_joe =
  %Team{
    name: "Hot Ice (Joe)",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-12-04], ~T[21:00:00.000], "Etc/UTC")
team_hgj =
  %Team{
    name: "Team Harry/George/John",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

#
# PUT USERS IN TEAMS
#

Repo.preload(team_daryl, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [daryl])
|> Repo.update!()

Repo.preload(team_tom, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [tom, jerry])
|> Repo.update!()

Repo.preload(team_joe, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [joe])
|> Repo.update!()

Repo.preload(team_hgj, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [harry, george, john])
|> Repo.update!()

#
# PUT TEAMS IN AUCTIONS
#

Repo.preload(auction_1988_1991_SL, [:teams])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:teams, [team_tom,
                                     team_joe,
                                     team_daryl,
                                     team_hgj])
|> Repo.update!()

#
# GIVE THE AUCTIONS AN ADMIN
#

Repo.preload(auction_1988_1991_SL, [:admins])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:admins, [daryl])
|> Repo.update!()

#
# PLAYERS FROM AUCTION
#

player1 = Repo.get!(Player, 1)
player2 = Repo.get!(Player, 2)
player3 = Repo.get!(Player, 3)
player4 = Repo.get!(Player, 4)

#
# CREATE A BID
#

bid_amount = 2
hidden_high_bid = 5
{:ok, now} = DateTime.now("Etc/UTC")
attrs = %{bid_amount: bid_amount,
          hidden_high_bid: hidden_high_bid,
          expires_at: DateTime.add(now, auction_1988_1991_SL.bid_timeout_seconds, :second),
          # the below line is an alternative to the above for testing
          # expires_at: DateTime.add(now, 10, :second),
          player: player1}
Ssauction.SingleAuction.submit_new_bid(auction_1988_1991_SL, team_tom, player1, attrs)

#
# ROSTER PLAYERS
#

# player_cost = 4
# rostered_player =
#   %RosteredPlayer{
#     cost: player_cost,
#     player: player1
#   }
# rostered_player = Ecto.build_assoc(team_daryl, :rostered_players, rostered_player)
# rostered_player = Ecto.build_assoc(auction_1988_1991_SL, :rostered_players, rostered_player)
# Repo.insert!(rostered_player)

# player_cost = 2
# rostered_player =
#   %RosteredPlayer{
#     cost: player_cost,
#     player: player2
#   }
# rostered_player = Ecto.build_assoc(team_daryl, :rostered_players, rostered_player)
# rostered_player = Ecto.build_assoc(auction_1988_1991_SL, :rostered_players, rostered_player)
# Repo.insert!(rostered_player)

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
