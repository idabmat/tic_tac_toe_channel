defmodule TicTacToeChannelWeb.Router do
  use TicTacToeChannelWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", TicTacToeChannelWeb do
    pipe_through(:api)
  end
end
