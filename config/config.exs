# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :tic_tac_toe_channel, TicTacToeChannelWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "I+GjFLbK0MYlOM7cnzcU6Dubl61GWG2dPQENRYFPVAU7lGgseAu2mJoPeEbD2i0+",
  render_errors: [view: TicTacToeChannelWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TicTacToeChannel.PubSub,
  live_view: [signing_salt: "FmEDUNZ_zDDLRwAP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
