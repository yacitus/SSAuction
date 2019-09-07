defmodule SsauctionWeb.Resolvers.SingleAuction do
  alias Ssauction.SingleAuction
  alias SsauctionWeb.Schema.ChangesetErrors

  def auction(_, %{id: id}, _) do
    {:ok, SingleAuction.get_auction_by_id!(id)}
  end

  def auctions(_, _, _) do
    {:ok, SingleAuction.get_all_auctions()}
  end

  def teams_in_auction(_, %{auction_id: auction_id}, _) do
    {:ok, SingleAuction.get_auction_by_id!(auction_id) |> SingleAuction.list_teams()}
  end

  def team(_, %{id: id}, _) do
    {:ok, SingleAuction.get_team_by_id!(id)}
  end

  def bids_in_auction(auction, _, _) do
    {:ok, SingleAuction.get_bids_in_auction!(auction)}
  end

  def start_auction(_, args, %{context: %{current_user: user}}) do
    auction = SingleAuction.get_auction_by_id!(args[:auction_id])

    # make sure the user is an admin for the auction or is super
    if (SingleAuction.user_is_auction_admin?(user, auction)) do
      case SingleAuction.start_auction(auction) do
        {:error, changeset} ->
          {
            :error,
            message: "Could not start auction!",
            details: ChangesetErrors.error_details(changeset)
          }

        {:ok, auction} ->
          {:ok, auction}
      end
    else
      {
        :error,
        message: "User not authorized to change auction"
      }
    end
  end

  def pause_auction(_, args, %{context: %{current_user: user}}) do
    auction = SingleAuction.get_auction_by_id!(args[:auction_id])

    # make sure the user is an admin for the auction or is super
    if (SingleAuction.user_is_auction_admin?(user, auction)) do
      case SingleAuction.pause_auction(auction) do
        {:error, changeset} ->
          {
            :error,
            message: "Could not pause auction!",
            details: ChangesetErrors.error_details(changeset)
          }

        {:ok, auction} ->
          {:ok, auction}
      end
    else
      {
        :error,
        message: "User not authorized to change auction"
      }
    end
  end

  def submit_bid(_, args, %{context: %{current_user: user}}) do
    auction = SingleAuction.get_auction_by_id!(args[:auction_id])
    team = SingleAuction.get_team_by_id!(args[:team_id])
    player = SingleAuction.get_player_by_id!(args[:player_id])

    # make sure the team is in the auction
    if (SingleAuction.team_is_in_auction?(team, auction)) do
      # make sure the user is in the team submitting the bid
      if (SingleAuction.user_is_team_member?(user, team)) do
        {:ok, utc_datetime} = DateTime.now("Etc/UTC")
        args = Map.put(args,
                       :expires_at,
                       DateTime.add(utc_datetime, auction.bid_timeout_seconds, :second))

        case SingleAuction.submit_bid(auction, team, player, args) do
          {:error, changeset} ->
            {
              :error,
              message: "Could not submit bid!",
              details: ChangesetErrors.error_details(changeset)
            }

          {:ok, bid} ->
            {:ok, bid}
        end
      else
        {
          :error,
          message: "User not member of team submitting bid"
        }
      end
    else
        {
          :error,
          message: "Team is not in auction"
        }
    end
  end
end
