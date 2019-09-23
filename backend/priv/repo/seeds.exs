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
# alias Ssauction.Bid
alias Ssauction.RosteredPlayer
alias Ssauction.OrderedPlayer

#
# PLAYERS
#


year_range = "1985-1988"

"players.csv"
|> Path.expand(__DIR__)
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(&String.split(&1, ","))
|> Enum.map(fn [ssnum, name, position] ->
     %Player{}
     |> Player.changeset(%{
          year_range: year_range,
          name: name,
          ssnum: ssnum,
          position: String.trim_trailing(position)
        })
     |> Repo.insert!
   end)

player1 = Repo.get!(Player, 1)
player2 = Repo.get!(Player, 2)
player3 = Repo.get!(Player, 3)
player4 = Repo.get!(Player, 4)

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
      password: "secret"
    })
  |> Repo.insert!

bob =
  %User{}
  |> User.changeset(%{
      username: "bob",
      email: "bob@example.com",
      slack_display_name: "bob",
      password: "secret"
    })
  |> Repo.insert!

fred =
  %User{}
  |> User.changeset(%{
      username: "fred",
      email: "fred@example.com",
      slack_display_name: "fred",
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
    players_per_team: 2,
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

bid_amount = 2
{:ok, utc_datetime} = DateTime.now("Etc/UTC")
attrs = %{bid_amount: bid_amount,
          # the commented line below is correct, but the line below that is for testing
          # expires_at: DateTime.add(utc_datetime, auction.bid_timeout_seconds, :second),
          expires_at: DateTime.add(utc_datetime, 600, :second),
          player: player1}
Ssauction.SingleAuction.submit_new_bid(auction, team_daryl, player1, attrs)

Team.changeset(team_daryl, %{unused_nominations: team_daryl.unused_nominations-1,
                             dollars_bid: team_daryl.dollars_bid + bid_amount,
                             time_of_last_nomination: utc_datetime})
|> Repo.update!()

Auction.changeset(auction, %{started_or_paused_at: utc_datetime})
|> Repo.update!()

#
# ROSTER A PLAYER
#

player_cost = 4
rostered_player =
  %RosteredPlayer{
    cost: player_cost,
    player: player2
  }
rostered_player = Ecto.build_assoc(team_two, :rostered_players, rostered_player)
rostered_player = Ecto.build_assoc(auction, :rostered_players, rostered_player)
Repo.insert!(rostered_player)

Team.changeset(team_two, %{dollars_spent: team_daryl.dollars_spent + player_cost})
|> Repo.update!()

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
