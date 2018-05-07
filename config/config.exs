# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wondertasks,
  ecto_repos: [Wondertasks.Repo]

# Configures the endpoint
config :wondertasks, WondertasksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8VFMYbfpHQ3aZDUC3KOHx9mXeIvzTP5QWaMtjLo/6ycJYgQYmco6R9hRPLytD0D3",
  render_errors: [view: WondertasksWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Wondertasks.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
