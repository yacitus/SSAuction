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

alias Ssauction.Repo
alias Ssauction.User
alias Ssauction.Player
alias Ssauction.Team
alias Ssauction.Auction
alias Ssauction.Bid
alias Ssauction.RosteredPlayer
alias Ssauction.OrderedPlayer

#
# PLAYERS
#

year_range = "1985-1988"

player1 =
  %Player{}
  |> Player.changeset(%{
      year_range: year_range,
      name: "Orel Hershiser",
      ssnum: 1,
      position: "SP"
     })
  |> Repo.insert!

player2 =
  %Player{}
  |> Player.changeset(%{
      year_range: year_range,
      name: "Mike Scott",
      ssnum: 2,
      position: "SP"
     })
  |> Repo.insert!

player3 =
  %Player{}
  |> Player.changeset(%{
      year_range: year_range,
      name: "Dwight Gooden",
      ssnum: 3,
      position: "SP"
     })
  |> Repo.insert!

player4 =
  %Player{}
  |> Player.changeset(%{
      year_range: year_range,
      name: "Rick Mahler",
      ssnum: 4,
      position: "SP"
     })
  |> Repo.insert!

#
# USERS
#

daryl =
  %User{}
  |> User.changeset(%{
      username: "daryl",
      email: "daryl.spitzer@gmail.com",
      super: true,
      password: "secret"
    })
  |> Repo.insert!

bob =
  %User{}
  |> User.changeset(%{
      username: "bob",
      email: "bob@example.com",
      password: "secret"
    })
  |> Repo.insert!

fred =
  %User{}
  |> User.changeset(%{
      username: "fred",
      email: "fred@example.com",
      password: "secret"
    })
  |> Repo.insert!

#
# TEAMS
#

team_daryl =
  %Team{
    name: "Team Daryl",
    } |> Repo.insert!

team_two =
  %Team{
    name: "Team Two",
    } |> Repo.insert!

#
# PUT USERS IN TEAMS
#

Repo.preload(team_daryl, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [daryl])
|> Repo.update!()

Repo.preload(team_two, [:users])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:users, [bob, fred])
|> Repo.update!()

#
# AUCTION
#

auction =
  %Auction{
    name: "Test Auction",
    year_range: year_range,
    players_per_team: 1,
    team_dollars_per_player: 10,
    } |> Repo.insert!

#
# PUT TEAMS IN AUCTION
#

Repo.preload(auction, [:teams])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:teams, [team_daryl, team_two])
|> Repo.update!()

#
# GIVE THE AUCTION AN ADMIN
#

Repo.preload(auction, [:admins])
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_assoc(:admins, [bob])
|> Repo.update!()

#
# CREATE A BID
#

{:ok, utc_datetime} = DateTime.now("Etc/UTC")
bid =
  %Bid{
    bid_amount: 2,
    expires_at: DateTime.add(utc_datetime, auction.bid_timeout_seconds, :second),
    player: player1
  }
bid = Ecto.build_assoc(team_daryl, :bids, bid)
bid = Ecto.build_assoc(auction, :bids, bid)
Repo.insert!(bid)

Team.changeset(team_daryl, %{unused_nominations: team_daryl.unused_nominations-1,
                             time_of_last_nomination: utc_datetime})
|> Repo.update!()

#
# ROSTER A PLAYER
#

rostered_player =
  %RosteredPlayer{
    cost: 4,
    player: player2
  }
rostered_player = Ecto.build_assoc(team_two, :rostered_players, rostered_player)
Repo.insert!(rostered_player)

#
# ADD A PLAYER TO A TEAM'S NOMINATION LIST
#

ordered_player =
  %OrderedPlayer{
    rank: 1,
    player: player3
  }
ordered_player = Ecto.build_assoc(team_daryl, :ordered_players, ordered_player)
Repo.insert!(ordered_player)

#
# ADD A PLAYER TO AN AUCTION'S AUTO-NOMINATION LIST
#

ordered_player =
  %OrderedPlayer{
    rank: 1,
    player: player4
  }
ordered_player = Ecto.build_assoc(auction, :ordered_players, ordered_player)
Repo.insert!(ordered_player)
