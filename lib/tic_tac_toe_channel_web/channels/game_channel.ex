defmodule TicTacToeChannelWeb.GameChannel do
  use TicTacToeChannelWeb, :channel
  alias TicTacToeChannel.GameServer
  alias TicTacToeChannel.GameSupervisor

  def join("game:new", _, socket) do
    {:ok, socket}
  end

  def handle_in("get_state", _, socket) do
    game = socket.assigns.game_pid |> GameServer.state()
    push(socket, "game_state", Map.from_struct(game))
    {:reply, :ok, socket}
  end

  def handle_in("player_move", position, socket) do
    game = socket.assigns.game_pid |> GameServer.player_move(position)
    if game.winner, do: stop_existing_game(socket)
    push(socket, "game_state", Map.from_struct(game))
    {:reply, :ok, socket}
  end

  def handle_in("computer_move", _, socket) do
    game = socket.assigns.game_pid |> GameServer.computer_move()
    if game.winner, do: stop_existing_game(socket)
    push(socket, "game_state", Map.from_struct(game))
    {:reply, :ok, socket}
  end

  def handle_in("new_game", game_mode, socket) when game_mode in ["notakto", "misere"] do
    game_mode = String.to_atom(game_mode)
    {:ok, pid} = start_game(socket, game_mode)
    socket = socket |> assign(:game_pid, pid)
    handle_in("get_state", nil, socket)
  end

  def handle_in("new_game", _, socket) do
    {:ok, pid} = start_game(socket, :original)
    socket = socket |> assign(:game_pid, pid)
    handle_in("get_state", nil, socket)
  end

  def terminate(_reason, socket) do
    stop_existing_game(socket)
  end

  defp start_game(socket, game_mode) do
    stop_existing_game(socket)
    GameSupervisor.launch_new_game(game_mode)
  end

  defp stop_existing_game(socket) do
    if pid = Map.get(socket.assigns, :game_pid), do: GameSupervisor.stop_game(pid)
  end
end
