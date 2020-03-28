# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :cors_plug,
  origin: ["http://localhost:5000"],
  max_age: 86400,
  methods: ["GET", "POST"]

# General application configuration
config :ssauction,
  ecto_repos: [Ssauction.Repo]

# Configures the endpoint
config :ssauction, SsauctionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dW2a2d/wz/5erqRsgIQ2E/5A1kJa2TG66UcHYvnFjpgf6N+i1wNrRaDqoO+G2APd",
  render_errors: [view: SsauctionWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ssauction.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
