# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config
import_config "env.local.exs"

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

# Configure to join with other node
config :portal, join_addr: System.get_env("JOIN_TO")

# Configures Elixir's Logger
config :logger, :console,
    format: "$time $metadata[$level] $message\n",
    metadata: [:request_id]

config :guardian, Guardian,
    issuer: "Portal.#{node()}",
    verify_issuer: true,
    secret_key: "BDjxhdF0yOf5c2eXa7KY2PwRLvTHkC/yktktEFzrkWtzqiLGmwLZY+Ohd/cYKnVX",
    serializer: Portal.GuardianSerializer

config :portal, :google,
    client_id: System.get_env("GOOGLE_CLIENT_ID"), 
    client_secret: System.get_env("GOOGLE_CLIENT_SECRET"), 
    redirect_url: System.get_env("GOOGLE_REDIRECT_URI"), 
    scopes: ["email", "profile", "https://www.googleapis.com/auth/drive"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
