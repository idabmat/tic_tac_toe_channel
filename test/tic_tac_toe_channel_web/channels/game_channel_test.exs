defmodule TicTacToeChannelWeb.GameChannelTest do
  use TicTacToeChannelWeb.ChannelCase

  alias TicTacToeChannelWeb.GameChannel
  alias TicTacToeChannel.GameSupervisor

  setup do
    {:ok, _, socket} =
      TicTacToeChannelWeb.UserSocket
      |> socket("user_id", %{})
      |> subscribe_and_join(GameChannel, "game:new")

    %{socket: socket}
  end

  test "get game state", %{socket: socket} do
    ref = push(socket, "new_game")
    assert_reply ref, :ok

    ref = push(socket, "get_state")
    assert_reply ref, :ok

    board = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
    assert_push("game_state", %{board: ^board})
  end

  test "player makes a move", %{socket: socket} do
    ref = push(socket, "new_game")
    assert_reply ref, :ok

    ref = push(socket, "player_move", 5)
    assert_reply ref, :ok

    assert_push("game_state", %{})
  end

  test "ask computer to move", %{socket: socket} do
    ref = push(socket, "new_game")
    assert_reply ref, :ok

    ref = push(socket, "computer_move")
    assert_reply ref, :ok

    assert_push("game_state", %{})
  end

  test "get a new game", %{socket: socket} do
    ref = push(socket, "new_game", "original")
    assert_reply ref, :ok

    board = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
    assert_push("game_state", %{board: ^board, game_mode: :original})
  end

  test "get a new misere game", %{socket: socket} do
    ref = push(socket, "new_game", "misere")
    assert_reply ref, :ok

    board = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
    assert_push("game_state", %{board: ^board, game_mode: :misere})
  end

  test "get a new notakto game", %{socket: socket} do
    ref = push(socket, "new_game", "notakto")
    assert_reply ref, :ok

    board = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
    assert_push("game_state", %{board: ^board, game_mode: :notakto})
  end

  test "starting a new game when there was one in progress", %{socket: socket} do
    ref = push(socket, "new_game")
    assert_reply ref, :ok

    assert %{active: 1} = Supervisor.count_children(GameSupervisor)

    ref = push(socket, "new_game", "notakto")
    assert_reply ref, :ok

    assert %{active: 1} = DynamicSupervisor.count_children(GameSupervisor)
  end
end
