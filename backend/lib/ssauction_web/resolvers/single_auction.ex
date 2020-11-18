defmodule SsauctionWeb.Resolvers.SingleAuction do
  alias Ssauction.SingleAuction
  alias Ssauction.{Auction, Team}
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

  def queueable_players(team, _, _) do
    {:ok, SingleAuction.queueable_players(team)}
  end

  def users_in_team(_, %{team_id: team_id}, _) do
    {:ok, SingleAuction.get_team_by_id!(team_id) |> SingleAuction.list_users()}
  end

  def dollars_per_team(auction, _, _) do
    {:ok, SingleAuction.dollars_per_team(auction)}
  end

  def bid(_, %{id: id}, _) do
    {:ok, SingleAuction.get_bid_by_id!(id)}
  end

  def bids_in_auction(auction, _, _) do
    {:ok, SingleAuction.list_bids_in_auction!(auction)}
  end

  def team_dollars_spent(team, _, _) do
    {:ok, SingleAuction.team_dollars_spent(team)}
  end

  def team_dollars_bid(team, _, _) do
    {:ok, SingleAuction.team_dollars_bid(team)}
  end

  def team_dollars_remaining_for_bids(team, _, _) do
    {:ok, SingleAuction.team_dollars_remaining_for_bids(team)}
  end

  def set_auction_active_or_inactive(root, args, info) do
    case args[:active] do
      true ->
        start_auction(root, args, info)

      _ ->
         pause_auction(root, args, info)
     end
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
          publish_auction_status_change(auction)
          publish_nomination_queue_change(auction)
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
          publish_auction_status_change(auction)
          publish_nomination_queue_change(auction)
          {:ok, auction}
      end
    else
      {
        :error,
        message: "User not authorized to change auction"
      }
    end
  end

  def change_team_info(_, args, _) do
    SingleAuction.change_team_info(SingleAuction.get_team_by_id!(args[:team_id]), args)
    {:ok, SingleAuction.get_team_by_id!(args[:team_id])}
  end

  def add_to_nomination_queue(_, args, %{context: %{current_user: _user}}) do
    team = SingleAuction.get_team_by_id!(args[:team_id])
    player = SingleAuction.get_player_by_id!(args[:player_id])

    cond do
      not SingleAuction.queueable_player?(player, team) ->
        {
          :error,
          message: "player not queueable"
        }

      true ->
        {:ok, SingleAuction.add_to_nomination_queue(player, team)}
    end
  end

  def num_rostered_players(team, _, _) do
    {:ok, SingleAuction.number_of_rostered_players_in_team(team)}
  end

  def nominations_open?(team, _, _) do
    auction = SingleAuction.get_auction_by_id!(team.auction_id)
    cond do
      not auction.active ->
        {:ok, false}
      not SingleAuction.team_has_open_roster_spot?(team, auction) ->
        {:ok, false}
      team.unused_nominations == 0 ->
        {:ok, false}
      true ->
        {:ok, true}
    end
  end

  def submit_bid(_, args, %{context: %{current_user: user}}) do
    auction = SingleAuction.get_auction_by_id!(args[:auction_id])
    team = SingleAuction.get_team_by_id!(args[:team_id])
    player = SingleAuction.get_player_by_id!(args[:player_id])

    cond do
      not auction.active ->
        {
          :error,
          message: "Auction is paused"
        }
      not SingleAuction.team_is_in_auction?(team, auction) ->
        {
          :error,
          message: "Team is not in auction"
        }
      not SingleAuction.user_is_team_member?(user, team) ->
        {
          :error,
          message: "User not member of team submitting bid"
        }
      SingleAuction.player_is_rostered?(player) ->
        {
          :error,
          message: "Player is already rostered"
        }
      not hidden_high_bid_legal?(args[:hidden_high_bid], args[:bid_amount]) ->
        {
          :error,
          message: "Hidden high bid must be nil or above bid amount"
        }
      not SingleAuction.player_in_bids?(player) ->
        cond do
          not SingleAuction.legal_team_bid_amount?(auction, team, args, nil) ->
            {
              :error,
              message: "Bid amount not legal for team"
            }
          not SingleAuction.team_has_open_roster_spot?(team, auction) ->
            {
              :error,
              message: "Team does not have open roster spot for another bid"
            }
          team.unused_nominations == 0 ->
            {
              :error,
              message: "Team does not have an open nomination"
            }
          true ->
            submit_bid_changeset(auction, team, player, args, nil)
        end
      true ->
        existing_bid = SingleAuction.get_players_bid!(player)

        cond do
          args[:bid_amount] < existing_bid.bid_amount ->
            {
              :error,
              message: "Bid amount cannot be reduced"
            }
          args[:team_id] != existing_bid.team_id ->
            cond do
              not SingleAuction.legal_team_bid_amount?(auction, team, args, nil) ->
                {
                  :error,
                  message: "Bid amount not legal for team"
                }
              args[:bid_amount] <= existing_bid.bid_amount ->
                {
                  :error,
                  message: "Existing bid amount must be increased"
                }
              not SingleAuction.team_has_open_roster_spot?(team, auction) ->
                {
                  :error,
                  message: "Team does not have open roster spot for another bid"
                }
              existing_bid.hidden_high_bid != nil and not(args[:bid_amount] > existing_bid.hidden_high_bid) ->
                  submit_new_bid_amount_changeset(auction, existing_bid, args)
              true ->
                submit_bid_changeset(auction, team, player, args, existing_bid)
            end
          not SingleAuction.legal_team_bid_amount?(auction, team, args, existing_bid) ->
            {
              :error,
              message: "Bid amount not legal for team"
            }
          args[:bid_amount] != existing_bid.bid_amount ->
            {
              :error,
              message: "Cannot out-bid yourself"
            }
          true ->
            submit_bid_changeset(auction, team, player, args, existing_bid)
        end
    end
  end

  defp add_expires_at_to_args(args, auction) do
    {:ok, utc_datetime} = DateTime.now("Etc/UTC")
    Map.put(args, :expires_at, DateTime.add(utc_datetime, auction.bid_timeout_seconds, :second))
  end

  def submit_bid_changeset(auction, team, player, args, nil) do
    args = add_expires_at_to_args(args, auction)

    args = if not Map.has_key?(args, :hidden_high_bid) do
      Map.put(args, :hidden_high_bid, nil)
    else
      args
    end

    case SingleAuction.submit_new_bid(auction, team, player, args) do
      {:error, changeset} ->
        {
          :error,
          message: "Could not submit bid!",
          details: ChangesetErrors.error_details(changeset)
        }

      {:ok, bid} ->
        SingleAuction.update_team_info_post_nomination(team, args)
        SingleAuction.remove_from_nomination_queues(player, auction)
        publish_nomination_queue_change(auction)
        publish_bid_change(auction, team)
        {:ok, bid}
    end
  end

  def submit_bid_changeset(auction, team, _player, args, existing_bid) do
    args = if team.id != existing_bid.team_id do
      add_expires_at_to_args(args, auction)
    else
      args
    end

    args = if not Map.has_key?(args, :hidden_high_bid) do
      Map.put(args, :hidden_high_bid, nil)
    else
      args
    end

    case SingleAuction.update_existing_bid(existing_bid, team, args) do
      {:error, changeset} ->
        {
          :error,
          message: "Could not update bid!",
          details: ChangesetErrors.error_details(changeset)
        }

      {:ok, bid} ->
        publish_bid_change(auction, team)
        previous_team = SingleAuction.get_team_by_id!(existing_bid.team_id)
        publish_bid_change(auction, previous_team)
        {:ok, bid}
    end
  end

  defp submit_new_bid_amount_changeset(auction, existing_bid, args) do
    case SingleAuction.update_existing_bid_amount(existing_bid, args.bid_amount) do
      {:error, changeset} ->
        {
          :error,
          message: "Could not update bid!",
          details: ChangesetErrors.error_details(changeset)
        }

      {:ok, bid} ->
        team = SingleAuction.get_team_by_id!(existing_bid.team_id)
        publish_bid_change(auction, team)
        {:ok, bid}
    end
  end

  def publish_nomination_queue_change(auction = %Auction{}) do
    for team <- SingleAuction.list_teams(auction) do
      publish_nomination_queue_change(team)
    end
  end

  def publish_nomination_queue_change(team = %Team{}) do
    Absinthe.Subscription.publish(
      SsauctionWeb.Endpoint,
      team,
      nomination_queue_change: team.id
    )
  end

  def publish_queueable_players_change(team) do
    Absinthe.Subscription.publish(
      SsauctionWeb.Endpoint,
      team,
      queueable_players_change: team.id
    )
  end

  defp publish_auction_status_change(auction) do
    Absinthe.Subscription.publish(
      SsauctionWeb.Endpoint,
      auction,
      auction_status_change: auction.id
    )
  end

  def publish_bid_change(auction, team) do
    Absinthe.Subscription.publish(
      SsauctionWeb.Endpoint,
      team,
      team_bid_change: team.id
    )
    Absinthe.Subscription.publish(
      SsauctionWeb.Endpoint,
      auction,
      auction_bid_change: auction.id
    )
  end

  def publish_roster_change(auction, team) do
    Absinthe.Subscription.publish(
      SsauctionWeb.Endpoint,
      team,
      team_roster_change: team.id
    )
    Absinthe.Subscription.publish(
      SsauctionWeb.Endpoint,
      auction,
      auction_roster_change: auction.id
    )
  end

  def publish_team_info_change(team) do
    Absinthe.Subscription.publish(
      SsauctionWeb.Endpoint,
      team,
      team_info_change: team.id
    )
    publish_nomination_queue_change(team)
  end

  def publish_auction_teams_info_change(auction) do
    Absinthe.Subscription.publish(
      SsauctionWeb.Endpoint,
      SingleAuction.list_teams(auction),
      auction_teams_info_change: auction.id
    )
  end

  defp hidden_high_bid_legal?(nil, _) do
    true
  end

  defp hidden_high_bid_legal?(hidden, bid_amount) do
    hidden > bid_amount
  end
end
