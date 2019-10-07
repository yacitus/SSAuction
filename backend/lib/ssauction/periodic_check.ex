defmodule Ssauction.PeriodicCheck do
  use GenServer

  alias Ssauction.SingleAuction

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    SingleAuction.check_for_expired_bids()

    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1000)
  end
end
