defmodule TicTacToeChannel.GameServer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  def state(identifier) do
    GenServer.call(identifier, {:game_state})
  end

  def player_move(identifier, position) do
    GenServer.call(identifier, {:player_move, position})
  end

  def computer_move(identifier) do
    GenServer.call(identifier, {:computer_move})
  end

  @impl GenServer
  def init(game_mode) do
    {:ok, TicTacToe.new_game(game_mode)}
  end

  @impl GenServer
  def handle_call({:game_state}, _from, game) do
    {:reply, game, game}
  end

  def handle_call({:player_move, position}, _from, game) do
    game = TicTacToe.player_move(game, position)
    {:reply, game, game}
  end

  def handle_call({:computer_move}, _from, game) do
    game = TicTacToe.computer_move(game)
    {:reply, game, game}
  end
end
