use Mix.Config

# Configure your database
config :quick_poll, QuickPoll.Repo,
  username: "postgres",
  password: "postgres",
  database: "quick_poll_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :quick_poll, QuickPollWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
