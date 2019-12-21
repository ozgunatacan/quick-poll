# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :quick_poll,
  ecto_repos: [QuickPoll.Repo]

config :quick_poll, QuickPoll.Repo, migration_timestamps: [type: :utc_datetime]

# Configures the endpoint
config :quick_poll, QuickPollWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gHgQ0vWOEa92pz/q4vymx78fjRkEpDGVV2o4/l9mZhdlhTLVev2hUd2vc7wFLXGE",
  render_errors: [view: QuickPollWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: QuickPoll.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
