defmodule SsauctionWeb.Schema.Schema do
  use Absinthe.Schema
  alias Ssauction.SingleAuction

  import_types Absinthe.Type.Custom
  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]

  alias SsauctionWeb.Resolvers
  alias SsauctionWeb.Schema.Middleware

  query do
    @desc "Get an auction by its id"
    field :auction, :auction do
      arg :id, non_null(:integer)
      resolve &Resolvers.SingleAuction.auction/3
    end

    @desc "Get a list of all auctions"
    field :auctions, list_of(:auction) do
      resolve &Resolvers.SingleAuction.auctions/3
    end

    @desc "Get a list of teams in an auction"
    field :teams, list_of(:team) do
      arg :auction_id, non_null(:integer)
      resolve &Resolvers.SingleAuction.teams_in_auction/3
    end

    @desc "Get a team by its id"
    field :team, :team do
      arg :id, non_null(:integer)
      resolve &Resolvers.SingleAuction.team/3
    end

    @desc "Get a list of players who can be added to a team's nomination queue"
    field :queueable_players, list_of(:player) do
      arg :team_id, non_null(:integer)
      resolve &Resolvers.SingleAuction.queueable_players/3
    end

    @desc "Get a list of users in a team"
    field :users, list_of(:user) do
      arg :team_id, non_null(:integer)
      resolve &Resolvers.SingleAuction.users_in_team/3
    end

    @desc "Get a user by its id"
    field :user, :user do
      arg :id, non_null(:integer)
      resolve &Resolvers.Accounts.user/3
    end

    @desc "Get the currently signed-in user"
    field :me, :user do
      resolve &Resolvers.Accounts.me/3
    end

    @desc "Return true if current user is an auction admin"
    field :me_auction_admin, :boolean do
      arg :auction_id, non_null(:integer)
      resolve &Resolvers.Accounts.me_auction_admin/3
    end

    @desc "Return true if current user is in the team"
    field :me_in_team, :boolean do
      arg :team_id, non_null(:integer)
      resolve &Resolvers.Accounts.me_in_team/3
    end

    @desc "Get a bid by its id"
    field :bid, :bid do
      arg :id, non_null(:integer)
      resolve &Resolvers.SingleAuction.bid/3
    end
  end

  mutation do
    @desc "Start the auction if it's paused"
    field :start_auction, :auction do
      arg :auction_id, non_null(:id)
      middleware Middleware.Authenticate
      middleware Middleware.AuthorizeUserAuctionAdmin
      resolve &Resolvers.SingleAuction.start_auction/3
    end

    @desc "Pause the auction if it's active"
    field :pause_auction, :auction do
      arg :auction_id, non_null(:id)
      middleware Middleware.Authenticate
      middleware Middleware.AuthorizeUserAuctionAdmin
      resolve &Resolvers.SingleAuction.pause_auction/3
    end

    @desc "Either start or pause the auction"
    field :set_auction_active_or_inactive, :auction do
      arg :auction_id, non_null(:id)
      arg :active, non_null(:boolean)
      middleware Middleware.Authenticate
      middleware Middleware.AuthorizeUserAuctionAdmin
      resolve &Resolvers.SingleAuction.set_auction_active_or_inactive/3
    end

    @desc "Add a player to a team's nomination queue"
    field :add_to_nomination_queue, list_of(:ordered_player) do
      arg :team_id, non_null(:integer)
      arg :player_id, non_null(:integer)
      middleware Middleware.Authenticate
      middleware Middleware.AuthorizeUserInTeam
      resolve &Resolvers.SingleAuction.add_to_nomination_queue/3
    end


    @desc "Submit a bid"
    field :submit_bid, :bid do
      arg :auction_id, non_null(:integer)
      arg :team_id, non_null(:integer)
      arg :player_id, non_null(:integer)
      arg :bid_amount, non_null(:integer)
      arg :hidden_high_bid, :integer
      middleware Middleware.Authenticate
      middleware Middleware.AuthorizeUserInTeam
      resolve &Resolvers.SingleAuction.submit_bid/3
    end

    @desc "Sign in a user"
    field :signin, :session do
      arg :username, non_null(:string)
      arg :password, non_null(:string)
      resolve &Resolvers.Accounts.signin/3
    end
  end

  subscription do
    @desc "Subscribe to changes to a team's nomination queue"
    field :nomination_queue_change, :team do
      arg :id, non_null(:id)
      config fn args, _res ->
        {:ok, topic: args.id}
      end
    end

    @desc "Subscribe to changes to an auction's status"
    field :auction_status_change, :auction do
      arg :id, non_null(:id)
      config fn args, _res ->
        {:ok, topic: args.id}
      end
    end

    @desc "Subscribe to changes to an auction's bids"
    field :auction_bid_change, :auction do
      arg :id, non_null(:id)
      config fn args, _res ->
        {:ok, topic: args.id}
      end
    end
  end

  #
  # Object Types
  #

  object :user do
    field :id, non_null(:id)
    field :username, non_null(:string)
    field :email, non_null(:string)
    field :slack_display_name, non_null(:string)
  end

  object :session do
    field :user, non_null(:user)
    field :token, non_null(:string)
  end

  object :auction do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :year_range, non_null(:string)
    field :nominations_per_team, non_null(:integer)
    field :seconds_before_autonomination, non_null(:integer)
    field :bid_timeout_seconds, non_null(:integer)
    field :players_per_team, non_null(:integer)
    field :team_dollars_per_player, non_null(:integer)
    field :dollars_per_team, non_null(:integer) do
      resolve &Resolvers.SingleAuction.dollars_per_team/3
    end
    field :active, non_null(:boolean)
    field :started_or_paused_at, :datetime
    field :autonomination_queue, list_of(:ordered_player) do
      resolve dataloader(SingleAuction, :ordered_players, args: %{scope: :auction})
    end
    field :bids, list_of(:bid) do
      resolve &Resolvers.SingleAuction.bids_in_auction/3
    end
    field :rostered_players, list_of(:rostered_player) do
      resolve dataloader(SingleAuction, :rostered_players, args: %{scope: :auction})
    end
  end

  object :team do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :dollars_spent, non_null(:integer)
    field :dollars_bid, non_null(:integer)
    field :dollars_remaining_for_bids, non_null(:integer) do
      resolve &Resolvers.SingleAuction.team_dollars_remaining_for_bids/3
    end
    field :unused_nominations, non_null(:integer)
    field :time_of_last_nomination, :datetime
    field :users, list_of(:user) do
      resolve dataloader(SingleAuction, :users, args: %{scope: :team})
    end
    field :bids, list_of(:bid) do
      resolve dataloader(SingleAuction, :bids, args: %{scope: :team})
    end
    field :rostered_players, list_of(:rostered_player) do
      resolve dataloader(SingleAuction, :rostered_players, args: %{scope: :team})
    end
    field :nomination_queue, list_of(:ordered_player) do
      middleware Middleware.Authenticate
      middleware Middleware.AuthorizeUserInTeam
      resolve dataloader(SingleAuction, :ordered_players, args: %{scope: :team})
    end
  end

  object :bid do
    field :id, non_null(:id)
    field :bid_amount, non_null(:integer)
    field :hidden_high_bid, :integer do
      middleware Middleware.Authenticate
      middleware Middleware.AuthorizeUserInTeam
      middleware Absinthe.Middleware.MapGet, :hidden_high_bid
    end
    field :expires_at, non_null(:datetime)
    field :player, non_null(:player) do
      resolve dataloader(SingleAuction, :player, args: %{scope: :bid})
    end
    field :team, non_null(:team) do
      resolve dataloader(SingleAuction, :team, args: %{scope: :bid})
    end
  end

  object :player do
    field :id, non_null(:id)
    field :year_range, non_null(:string)
    field :ssnum, non_null(:integer)
    field :name, non_null(:string)
    field :position, non_null(:string)
  end

  object :rostered_player do
    field :cost, non_null(:integer)
    field :player, non_null(:player) do
      resolve dataloader(SingleAuction, :player, args: %{scope: :rostered_player})
    end
    field :team, non_null(:team) do
      resolve dataloader(SingleAuction, :team, args: %{scope: :rostered_player})
    end
 end

  object :ordered_player do
    field :rank, non_null(:integer)
    field :player, non_null(:player) do
      resolve dataloader(SingleAuction, :player, args: %{scope: :ordered_player})
    end
  end


  def context(ctx) do
    source = Dataloader.Ecto.new(Ssauction.Repo)

    loader =
      Dataloader.new
      |> Dataloader.add_source(SingleAuction, source)

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

end
