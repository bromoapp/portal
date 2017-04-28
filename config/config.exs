# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :portal,
  ecto_repos: [Portal.Repo]

# Configures the endpoint
config :portal, Portal.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "K2WzY86OVUIgIYqpw0McqYxywggi2hhDGWJONC+KNqshPD7n1mSTWWpzQeV4iOfM",
  render_errors: [view: Portal.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Portal.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "Portal",
  secret_key: Mix.env,
  serializer: Portal.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
