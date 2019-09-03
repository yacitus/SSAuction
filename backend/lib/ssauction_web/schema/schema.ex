defmodule SsauctionWeb.Schema.Schema do
  use Absinthe.Schema
  alias Ssauction.SingleAuction

  import_types Absinthe.Type.Custom

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
    field :started_or_paused_at, non_null(:datetime)
  end

end
