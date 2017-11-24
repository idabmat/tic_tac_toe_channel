defmodule TicTacToeChannelWeb.GameChannel do
  use TicTacToeChannelWeb, :channel

  def join("game:new", _, socket) do
    {:ok, socket}
  end

  def handle_in("get_state", _, socket) do
    game = socket.assigns.game_pid |> TicTacToe.game_state()
    push(socket, "game_state", game)
    {:noreply, socket}
  end

  def handle_in("player_move", position, socket) do
    game = socket.assigns.game_pid |> TicTacToe.player_move(position)
    push(socket, "game_state", game)
    {:noreply, socket}
  end

  def handle_in("computer_move", _, socket) do
    game = socket.assigns.game_pid |> TicTacToe.computer_move()
    push(socket, "game_state", game)
    {:noreply, socket}
  end

  def handle_in("new_game", "notakto", socket) do
    {:ok, pid} = TicTacToe.new_game(:notakto)
    socket = socket |> assign(:game_pid, pid)
    handle_in("get_state", nil, socket)
  end

  def handle_in("new_game", _, socket) do
    {:ok, pid} = TicTacToe.new_game(:original)
    socket = socket |> assign(:game_pid, pid)
    handle_in("get_state", nil, socket)
  end
end
