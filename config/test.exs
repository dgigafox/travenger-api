use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :travenger, TravengerWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :travenger, Travenger.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: "travenger_test",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
