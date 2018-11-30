# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :travenger,
  ecto_repos: [Travenger.Repo]

# Configures the endpoint
config :travenger, TravengerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "41OIhtSnQfO7KFfT6N/qdbt3p8DlGUoZrJAmDwbrFplqOeQ1fPHJLht5wuRfTXeJ",
  render_errors: [view: TravengerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Travenger.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
