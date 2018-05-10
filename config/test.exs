use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :weekly_pickem, WeeklyPickemWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :weekly_pickem, WeeklyPickem.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "weekly_pickem_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Also include dev secrets for testing.
import_config "dev.secret.exs"
