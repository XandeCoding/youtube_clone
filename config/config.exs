# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :youtube_clone,
  ecto_repos: [YoutubeClone.Repo]

# Configures the endpoint
config :youtube_clone, YoutubeCloneWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ct/toXNQdXRvgFIPeHG77HpyLZZ1M2U6lZcj197gZuUp0gZVDCROVUqencEs8X8E",
  render_errors: [view: YoutubeCloneWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: YoutubeClone.PubSub,
  live_view: [signing_salt: "tcPTDfCG"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
