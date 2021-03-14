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
import Ecto.Changeset

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
alias Ssauction.BidLog

#
# moved from priv/repo/migrations/20210103215400_create_bid_logs.exs
#

# Repo.all(RosteredPlayer)
# |> Enum.each(fn rp ->
#                rp = Repo.preload(rp, [:player])
#                auction = Repo.get!(Auction, rp.auction_id)
#                %BidLog{}
#                |> BidLog.changeset(%{amount: rp.cost,
#                                      type: "R",
#                                      datetime: auction.started_or_paused_at})
#                |> Ecto.Changeset.put_assoc(:auction, auction)
#                |> Ecto.Changeset.put_assoc(:team, Repo.get!(Team, rp.team_id))
#                |> Ecto.Changeset.put_assoc(:player, rp.player)
#                |> Repo.insert()
#              end)

#
# ALL PLAYERS
#

year_range = "2021-2021-AL"
Repo.import_all_players_from_csv_file(Path.expand("#{year_range}_players.csv", __DIR__),
                                      year_range)

#
# 2021-AL AUCTION
#

{:ok, now} = DateTime.now("Etc/UTC")
now = now
  |> DateTime.truncate(:second)
  |> DateTime.add(-now.second, :second)

year_range = "2021-2021-AL"

auction_2021_AL = SingleAuction.create_auction(name: "2021-AL",
                                               year_range: year_range,
                                               nominations_per_team: 2,
                                               seconds_before_autonomination: 60*60,
                                               new_nominations_created: "time",
                                               initial_bid_timeout_seconds: 60*60*24,
                                               bid_timeout_seconds: 60*60*12,
                                               players_per_team: 50,
                                               must_roster_all_players: false,
                                               team_dollars_per_player: 20,
                                               started_or_paused_at: now)

#
# USERS
#

joe = Repo.one(from u in User, where: u.username == "joe")

# joe =
#   %User{}
#   |> User.changeset(%{
#       username: "joe",
#       email: "joe@manycycles.com",
#       slack_display_name: "@Joe Golton",
#       password: "GxRashA"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

tom = Repo.one(from u in User, where: u.username == "tom")

# tom =
#   %User{}
#   |> User.changeset(%{
#       username: "tom",
#       email: "han60man@aol.com",
#       slack_display_name: "@han60man",
#       password: "gnrPiTP"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

jeff = Repo.one(from u in User, where: u.username == "jeff")

# jeff =
#   %User{}
#   |> User.changeset(%{
#       username: "jeff",
#       email: "jeffreysarzynski@gmail.com",
#       slack_display_name: "@?",
#       password: "bSyzsEq"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

jim = Repo.one(from u in User, where: u.username == "jim")

# jim =
#   %User{}
#   |> User.changeset(%{
#       username: "jim",
#       email: "jvanetten62@gmail.com",
#       slack_display_name: "@Jim VanEtten",
#       password: "KUYNmXg"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

daryl = Repo.one(from u in User, where: u.username == "daryl")

# daryl =
#   %User{}
#   |> User.changeset(%{
#       username: "daryl",
#       email: "daryl.spitzer@gmail.com",
#       slack_display_name: "@daryl",
#       super: true,
#       password: "CxKtzVJ"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

dannyr = Repo.one(from u in User, where: u.username == "dannyr")

# dannyr =
#   %User{}
#   |> User.changeset(%{
#       username: "dannyr",
#       email: "dannyrrowe@gmail.com",
#       slack_display_name: "@Danny_Rowe",
#       super: true,
#       password: "SrPtWNd"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

tony = Repo.one(from u in User, where: u.username == "tony")

# tony =
#   %User{}
#   |> User.changeset(%{
#       username: "tony",
#       email: "tonydoherty61@comcast.net",
#       slack_display_name: "@Tony Doherty",
#       super: true,
#       password: "BrYQRXH"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

brian = Repo.one(from u in User, where: u.username == "brian")

# brian =
#   %User{}
#   |> User.changeset(%{
#       username: "brian",
#       email: "brianarbour@gmail.com",
#       slack_display_name: "@Brian Arbour",
#       super: true,
#       password: "hYMbJAu"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

roger = Repo.one(from u in User, where: u.username == "roger")

# roger =
#   %User{}
#   |> User.changeset(%{
#       username: "roger",
#       email: "roger.morgan@sasktel.net",
#       slack_display_name: "@Roger Morgan",
#       super: true,
#       password: "euQFNxf"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

dannyl = Repo.one(from u in User, where: u.username == "dannyl")

# dannyl =
#   %User{}
#   |> User.changeset(%{
#       username: "dannyl",
#       email: "laflamme7@hotmail.com",
#       slack_display_name: "@Danny",
#       super: true,
#       password: "gtRZXer"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

john = Repo.one(from u in User, where: u.username == "john")

# john =
#   %User{}
#   |> User.changeset(%{
#       username: "john",
#       email: "johndjones44@yahoo.com",
#       slack_display_name: "@johndjones44",
#       password: "YsenMtt"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

george = Repo.one(from u in User, where: u.username == "george")

# george =
#   %User{}
#   |> User.changeset(%{
#       username: "george",
#       email: "gejoycejr@gmail.com",
#       slack_display_name: "@George E Joyce Jr",
#       password: "dYhpsPv"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

harry = Repo.one(from u in User, where: u.username == "harry")

# harry =
#   %User{}
#   |> User.changeset(%{
#       username: "harry",
#       email: "haguilera1021@gmail.com",
#       slack_display_name: "@Harry",
#       password: "UZegTYX"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

bill = Repo.one(from u in User, where: u.username == "bill")

# bill =
#   %User{}
#   |> User.changeset(%{
#       username: "bill",
#       email: "bill.darden@gmail.com",
#       slack_display_name: "@Bill Darden",
#       password: "rtqSwxP"
#     })
#   |> Repo.insert!(on_conflict: :nothing)

#
# TEAMS (one team can't be in more than one auction yet)
#

{:ok, nomination_time} = DateTime.new(~D[2021-03-14], ~T[14:00:00.000], "Etc/UTC")
nomination_time = DateTime.truncate(nomination_time, :second)

# team_joe = Repo.one(from t in Team, where: t.name == "Hot Ice (Joe)")
# changeset = change(team_joe, new_nominations_open_at: nomination_time)
# Repo.update(changeset)

team_joe =
  %Team{
    name: "Hot Ice (Joe)",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!(on_conflict: :nothing)

# old_team_tom = Repo.one(from t in Team, where: t.name == "Team Tom & Jeff")
# changeset = change(old_team_tom, name: "Team Tom & Jeff - old")
# Repo.update(changeset)

{:ok, nomination_time} = DateTime.new(~D[2021-03-14], ~T[14:45:00.000], "Etc/UTC")
nomination_time = DateTime.truncate(nomination_time, :second)

# team_tom = Repo.one(from t in Team, where: t.name == "Team Tom & Jeff")
# changeset = change(team_tom, new_nominations_open_at: nomination_time)
# Repo.update(changeset)

team_tom =
  %Team{
    name: "Charm City Centaurs (Tom & Jeff)",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!(on_conflict: :nothing)

{:ok, nomination_time} = DateTime.new(~D[2021-03-14], ~T[15:00:00.000], "Etc/UTC")
nomination_time = DateTime.truncate(nomination_time, :second)

# team_jim = Repo.one(from t in Team, where: t.name == "Team Jim")
# changeset = change(team_jim, new_nominations_open_at: nomination_time)
# Repo.update(changeset)

team_jim =
  %Team{
    name: "Team Jim",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!(on_conflict: :nothing)

# old_team_daryl = Repo.one(from t in Team, where: t.name == "Team Daryl")
# changeset = change(old_team_daryl, name: "Team Daryl - old")
# Repo.update(changeset)

{:ok, nomination_time} = DateTime.new(~D[2021-03-14], ~T[15:45:00.000], "Etc/UTC")
nomination_time = DateTime.truncate(nomination_time, :second)

# team_daryl = Repo.one(from t in Team, where: t.name == "Team Daryl")
# changeset = change(team_daryl, new_nominations_open_at: nomination_time)
# Repo.update(changeset)

team_daryl =
  %Team{
    name: "Team Daryl",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!(on_conflict: :nothing)


{:ok, nomination_time} = DateTime.new(~D[2021-03-14], ~T[16:00:00.000], "Etc/UTC")
nomination_time = DateTime.truncate(nomination_time, :second)

# team_dannyr = Repo.one(from t in Team, where: t.name == "Team Danny Rowe")
# changeset = change(team_dannyr, new_nominations_open_at: nomination_time)
# Repo.update(changeset)

team_dannyr =
  %Team{
    name: "Team Danny Rowe",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!(on_conflict: :nothing)

{:ok, nomination_time} = DateTime.new(~D[2021-03-14], ~T[16:30:00.000], "Etc/UTC")
nomination_time = DateTime.truncate(nomination_time, :second)

# team_tony = Repo.one(from t in Team, where: t.name == "Holyoke Hooligans (Tony)")
# changeset = change(team_tony, new_nominations_open_at: nomination_time)
# Repo.update(changeset)

team_tony =
  %Team{
    name: "Holyoke Hooligans (Tony)",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!(on_conflict: :nothing)

{:ok, nomination_time} = DateTime.new(~D[2021-03-14], ~T[17:00:00.000], "Etc/UTC")
nomination_time = DateTime.truncate(nomination_time, :second)

# team_brian = Repo.one(from t in Team, where: t.name == "Team Brian")
# changeset = change(team_brian, new_nominations_open_at: nomination_time)
# Repo.update(changeset)

team_brian =
  %Team{
    name: "Team Brian",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!(on_conflict: :nothing)

{:ok, nomination_time} = DateTime.new(~D[2021-03-14], ~T[18:00:00.000], "Etc/UTC")
nomination_time = DateTime.truncate(nomination_time, :second)

# team_roger = Repo.one(from t in Team, where: t.name == "Team Roger")
# changeset = change(team_roger, new_nominations_open_at: nomination_time)
# Repo.update(changeset)

team_roger =
  %Team{
    name: "Prairie Gold (Roger)",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!(on_conflict: :nothing)

{:ok, nomination_time} = DateTime.new(~D[2021-03-14], ~T[19:00:00.000], "Etc/UTC")
nomination_time = DateTime.truncate(nomination_time, :second)

# team_dannyl = Repo.one(from t in Team, where: t.name == "Game Of Throws (Danny)")
# changeset = change(team_dannyl, new_nominations_open_at: nomination_time)
# Repo.update(changeset)

team_dannyl =
  %Team{
    name: "Game Of Throws (Danny)",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!(on_conflict: :nothing)

{:ok, nomination_time} = DateTime.new(~D[2021-03-14], ~T[20:00:00.000], "Etc/UTC")
nomination_time = DateTime.truncate(nomination_time, :second)

# team_john = Repo.one(from t in Team, where: t.name == "Team John & George")
# changeset = change(team_john, new_nominations_open_at: nomination_time)
# Repo.update(changeset)

team_john =
  %Team{
    name: "Team John & George",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!(on_conflict: :nothing)

{:ok, nomination_time} = DateTime.new(~D[2021-03-15], ~T[01:30:00.000], "Etc/UTC")
nomination_time = DateTime.truncate(nomination_time, :second)

# team_bill = Repo.one(from t in Team, where: t.name == "The Masked Crusaders (Bill)")
# changeset = change(team_bill, new_nominations_open_at: nomination_time)
# Repo.update(changeset)

team_bill =
  %Team{
    name: "The Masked Crusaders (Bill)",
    unused_nominations: 0,
    new_nominations_open_at: DateTime.truncate(nomination_time, :second),
    } |> Repo.insert!(on_conflict: :nothing)

#
# PUT USERS IN TEAMS
#

Repo.preload(team_joe, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [joe])
|> Repo.update!(on_conflict: :nothing)

Repo.preload(team_tom, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [tom, jeff])
|> Repo.update!(on_conflict: :nothing)

Repo.preload(team_jim, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [jim])
|> Repo.update!(on_conflict: :nothing)

Repo.preload(team_daryl, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [daryl])
|> Repo.update!(on_conflict: :nothing)

Repo.preload(team_dannyr, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [dannyr])
|> Repo.update!(on_conflict: :nothing)

Repo.preload(team_tony, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [tony])
|> Repo.update!(on_conflict: :nothing)

Repo.preload(team_brian, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [brian])
|> Repo.update!(on_conflict: :nothing)

Repo.preload(team_roger, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [roger])
|> Repo.update!(on_conflict: :nothing)

Repo.preload(team_dannyl, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [dannyl])
|> Repo.update!(on_conflict: :nothing)

Repo.preload(team_john, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [john, george])
|> Repo.update!(on_conflict: :nothing)

Repo.preload(team_bill, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [bill])
|> Repo.update!(on_conflict: :nothing)

#
# PUT TEAMS IN AUCTIONS
#

Repo.preload(auction_2021_AL, [:teams])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:teams, [team_joe,
                                     team_tom,
                                     team_jim,
                                     team_daryl,
                                     team_dannyr,
                                     team_tony,
                                     team_brian,
                                     team_roger,
                                     team_dannyl,
                                     team_john,
                                     team_bill])
|> Repo.update!(on_conflict: :nothing)

#
# GIVE THE AUCTIONS AN ADMIN
#

Repo.preload(auction_2021_AL, [:admins])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:admins, [daryl])
|> Repo.update!(on_conflict: :nothing)

#
# PLAYERS FROM AUCTION
#

# player1 = Repo.get!(Player, 1)
# player2 = Repo.get!(Player, 2)
# player3 = Repo.get!(Player, 3)
# player4 = Repo.get!(Player, 4)

#
# CREATE A BID
#

# bid_amount = 2
# hidden_high_bid = 5
# {:ok, now} = DateTime.now("Etc/UTC")
# attrs = %{bid_amount: bid_amount,
#           hidden_high_bid: hidden_high_bid,
#           expires_at: DateTime.add(now, auction_2021_AL.bid_timeout_seconds, :second),
#           # the below line is an alternative to the above for testing
#           # expires_at: DateTime.add(now, 10, :second),
#           player: player1}
# Ssauction.SingleAuction.submit_new_bid(auction_2021_AL, team_tom, player1, attrs)

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
# rostered_player = Ecto.build_assoc(auction_2021_AL, :rostered_players, rostered_player)
# Repo.insert!(rostered_player, on_conflict: :nothing)

# player_cost = 2
# rostered_player =
#   %RosteredPlayer{
#     cost: player_cost,
#     player: player2
#   }
# rostered_player = Ecto.build_assoc(team_daryl, :rostered_players, rostered_player)
# rostered_player = Ecto.build_assoc(auction_2021_AL, :rostered_players, rostered_player)
# Repo.insert!(rostered_player, on_conflict: :nothing)

#
# ADD A PLAYER TO A TEAM'S NOMINATION LIST
#

# ordered_player =
#   %OrderedPlayer{
#     rank: 1,
#     player: player3
#   }
# ordered_player = Ecto.build_assoc(team_daryl, :ordered_players, ordered_player)
# Repo.insert!(ordered_player, on_conflict: :nothing)

#
# ADD PLAYERS TO THE AUCTION'S AUTO-NOMINATION LIST
#

"2021-2021-AL_players_sorted_by_playing_time.csv"
|> Path.expand(__DIR__)
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(&String.split(&1, ","))
|> Enum.with_index(1)
|> Enum.map(fn {[_, ssnum, _], i} ->
    player = Repo.one!(from player in Player,
                        where: player.auction_id == ^auction_2021_AL.id and player.ssnum == ^ssnum,
                        select: player)
    ordered_player =
      %OrderedPlayer{
        rank: i,
        player: player
      }
    ordered_player = Ecto.build_assoc(auction_2021_AL, :ordered_players, ordered_player)
    Repo.insert!(ordered_player, on_conflict: :nothing)
   end)
