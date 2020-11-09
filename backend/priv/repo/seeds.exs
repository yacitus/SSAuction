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
now = now
  |> DateTime.truncate(:second)
  |> DateTime.add(-now.second, :second)

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
      slack_display_name: "?",
      password: "UZegTYX"
    })
  |> Repo.insert!

kyle =
  %User{}
  |> User.changeset(%{
      username: "kyle",
      email: "zorrofox12@yahoo.com",
      slack_display_name: "@Kyle Fox",
      password: "bjnQBdS"
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

lee =
  %User{}
  |> User.changeset(%{
      username: "lee",
      email: "laralee@att.net",
      slack_display_name: "@Lee Gootblatt",
      password: "JHvbujT"
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

rob =
  %User{}
  |> User.changeset(%{
      username: "rob",
      email: "rcmiller510@gmail.com",
      slack_display_name: "@Team12_Miller",
      password: "KVbVcwv"
    })
  |> Repo.insert!

alan =
  %User{}
  |> User.changeset(%{
      username: "alan",
      email: "coachmurf@aol.com",
      slack_display_name: "@Alan Murphy",
      password: "UWRGFeH"
    })
  |> Repo.insert!

ken =
  %User{}
  |> User.changeset(%{
      username: "ken",
      email: "kennadeau@aol.com",
      slack_display_name: "@Ken Nadeau",
      password: "zkBaXkZ"
    })
  |> Repo.insert!

scott =
  %User{}
  |> User.changeset(%{
      username: "scott",
      email: "scportnoy1955@gmail.com",
      slack_display_name: "@Scott Portnoy",
      password: "GbNHYkm"
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

#
# TEAMS (one team can't be in more than one auction yet)
#

{:ok, nomination_time} = DateTime.new(~D[2020-11-09], ~T[11:45:00.000], "Etc/UTC")
team_tom =
  %Team{
    name: "Team Tom",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-09], ~T[13:00:00.000], "Etc/UTC")
team_jerry =
  %Team{
    name: "Team Jerry",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-09], ~T[14:30:00.000], "Etc/UTC")
team_joe =
  %Team{
    name: "Team Joe",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-09], ~T[16:45:00.000], "Etc/UTC")
team_daryl =
  %Team{
    name: "Team Daryl",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-10], ~T[01:30:00.000], "Etc/UTC")
team_scott =
  %Team{
    name: "Team Scott",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-10], ~T[03:00:00.000], "Etc/UTC")
team_ken =
  %Team{
    name: "Team Ken",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-10], ~T[03:15:00.000], "Etc/UTC")
team_alan =
  %Team{
    name: "Team Alan",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-10], ~T[04:00:00.000], "Etc/UTC")
team_rob =
  %Team{
    name: "Team Rob",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-10], ~T[04:30:00.000], "Etc/UTC")
team_kyle =
  %Team{
    name: "Team Kyle",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-10], ~T[05:00:00.000], "Etc/UTC")
team_lee =
  %Team{
    name: "Team Lee",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-10], ~T[06:45:00.000], "Etc/UTC")
team_john =
  %Team{
    name: "Team John",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-10], ~T[07:00:00.000], "Etc/UTC")
team_george =
  %Team{
    name: "Team George",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!

{:ok, nomination_time} = DateTime.new(~D[2020-11-10], ~T[07:30:00.000], "Etc/UTC")
team_harry =
  %Team{
    name: "Team Harry",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
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

Repo.preload(team_john, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [john])
|> Repo.update!()

Repo.preload(team_harry, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [harry])
|> Repo.update!()

Repo.preload(team_kyle, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [kyle])
|> Repo.update!()

Repo.preload(team_joe, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [joe])
|> Repo.update!()

Repo.preload(team_lee, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [lee])
|> Repo.update!()

Repo.preload(team_george, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [george])
|> Repo.update!()

Repo.preload(team_rob, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [rob])
|> Repo.update!()

Repo.preload(team_alan, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [alan])
|> Repo.update!()

Repo.preload(team_ken, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [ken])
|> Repo.update!()

Repo.preload(team_scott, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [scott])
|> Repo.update!()

Repo.preload(team_jerry, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [jerry])
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
|> Ecto.Changeset.put_assoc(:teams, [team_tom,
                                     team_jerry,
                                     team_joe,
                                     team_daryl,
                                     team_scott,
                                     team_ken,
                                     team_alan,
                                     team_rob,
                                     team_kyle,
                                     team_lee,
                                     team_john,
                                     team_george,
                                     team_harry])
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
