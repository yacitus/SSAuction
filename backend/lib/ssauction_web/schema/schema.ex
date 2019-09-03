defmodule SsauctionWeb.Schema.Schema do
  use Absinthe.Schema
  alias Ssauction.SingleAuction

  import_types Absinthe.Type.Custom
  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]

  alias SsauctionWeb.Resolvers

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
  end

  #
  # Object Types
  #
  object :auction do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :year_range, non_null(:string)
    field :nominations_per_team, non_null(:integer)
    field :seconds_before_autonomination, non_null(:integer)
    field :bid_timeout_seconds, non_null(:integer)
    field :players_per_team, non_null(:integer)
    field :team_dollars_per_player, non_null(:integer)
    field :active, non_null(:boolean)
    field :started_or_paused_at, :datetime
    field :autonomination_queue, list_of(:ordered_player) do
      resolve dataloader(SingleAuction, :ordered_players, args: %{scope: :auction})
    end
  end

  object :team do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :dollars_spent, non_null(:integer)
    field :dollars_bid, non_null(:integer)
    field :unused_nominations, non_null(:integer)
    field :time_of_last_nomination, :datetime
    field :bids, list_of(:bid) do
      resolve dataloader(SingleAuction, :bids, args: %{scope: :team})
    end
    field :rostered_players, list_of(:rostered_player) do
      resolve dataloader(SingleAuction, :rostered_players, args: %{scope: :team})
    end
    field :nomination_queue, list_of(:ordered_player) do
      resolve dataloader(SingleAuction, :ordered_players, args: %{scope: :team})
    end
  end

  object :bid do
    field :id, non_null(:id)
    field :bid_amount, non_null(:integer)
    field :expires_at, non_null(:datetime)
    field :player, non_null(:player) do
      resolve dataloader(SingleAuction, :player, args: %{scope: :bid})
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
