defmodule Ssauction.Application do
  use Application

  defp append_if(list, condition, item) do
    if condition, do: list ++ [item], else: list
  end

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Ssauction.Repo, []),
      # Start the endpoint when the application starts
      supervisor(SsauctionWeb.Endpoint, []),

      supervisor(Absinthe.Subscription, [SsauctionWeb.Endpoint]),
    ]
    |> append_if(System.get_env("PERIODIC_CHECK") == "ON",
                 worker(Ssauction.PeriodicCheck, []))

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ssauction.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SsauctionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
