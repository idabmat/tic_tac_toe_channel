defmodule TicTacToeChannel.GameSupervisor do
  use DynamicSupervisor

  def start_link(init_args \\ []) do
    DynamicSupervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def launch_new_game(game_mode) do
    DynamicSupervisor.start_child(__MODULE__, {TicTacToeChannel.GameServer, game_mode})
  end

  def stop_game(game_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, game_pid)
  end

  @impl DynamicSupervisor
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
