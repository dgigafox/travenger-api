# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :travenger, ecto_repos: [Travenger.Repo]

# Configures the endpoint
config :travenger, TravengerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "41OIhtSnQfO7KFfT6N/qdbt3p8DlGUoZrJAmDwbrFplqOeQ1fPHJLht5wuRfTXeJ",
  render_errors: [view: TravengerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Travenger.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# CORS Plug
config :cors_plug,
  origin: ["*"],
  max_age: 86_400

# Ueberauth Config
# default_scope: "email,public_profile"
config :ueberauth, Ueberauth,
  providers: [
    facebook:
      {Ueberauth.Strategy.Facebook,
       [
         profile_fields: "id,email,name,first_name,last_name,gender,location"
       ]}
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: "1921038801247765",
  client_secret: "0b45c319eddc4279a92b0b5b0eb2b597"

# Guardian Config
config :travenger, Travenger.Account.Guardian,
  issuer: "Travenger",
  secret_key: "gPrZfGOEbw75/2Wa/xGKPKUdMXHPmEEXsWS9KU06i/Xe9hkPR4R201jUU5NT9gy0",
  verify_module: Guardian.JWT,
  allowed_algos: ["HS256"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
