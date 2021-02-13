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

  test "joining and leaving the channel", %{socket: socket} do
    Process.flag(:trap_exit, true)
    pid = socket.channel_pid

    assert %{active: 0} = DynamicSupervisor.count_children(GameSupervisor)

    ref = push(socket, "new_game")
    assert_reply ref, :ok

    assert %{active: 1} = DynamicSupervisor.count_children(GameSupervisor)

    ref = leave(socket)
    assert_reply ref, :ok

    assert_receive {:EXIT, ^pid, {:shutdown, :left}}
    assert %{active: 0} = DynamicSupervisor.count_children(GameSupervisor)
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

    ref = leave(socket)
    assert_reply ref, :ok
  end

  test "player makes a move", %{socket: socket} do
    ref = push(socket, "new_game")
    assert_reply ref, :ok

    ref = push(socket, "player_move", 5)
    assert_reply ref, :ok

    assert_push("game_state", %{})

    ref = leave(socket)
    assert_reply ref, :ok
  end

  test "ask computer to move", %{socket: socket} do
    ref = push(socket, "new_game")
    assert_reply ref, :ok

    ref = push(socket, "computer_move")
    assert_reply ref, :ok

    assert_push("game_state", %{})

    ref = leave(socket)
    assert_reply ref, :ok
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

    ref = leave(socket)
    assert_reply ref, :ok
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

    ref = leave(socket)
    assert_reply ref, :ok
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

    ref = leave(socket)
    assert_reply ref, :ok
  end

  test "starting a new game when there was one in progress", %{socket: socket} do
    ref = push(socket, "new_game")
    assert_reply ref, :ok

    assert %{active: 1} = DynamicSupervisor.count_children(GameSupervisor)

    ref = push(socket, "new_game", "notakto")
    assert_reply ref, :ok

    assert %{active: 1} = DynamicSupervisor.count_children(GameSupervisor)

    ref = leave(socket)
    assert_reply ref, :ok
  end
end
