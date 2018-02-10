defmodule TicTacToeChannelWeb.GameChannelTest do
  use TicTacToeChannelWeb.ChannelCase

  alias TicTacToeChannelWeb.GameChannel

  setup do
    {:ok, _, socket} =
      socket()
      |> subscribe_and_join(GameChannel, "game:new")

    {:ok, socket: socket}
  end

  test "get game state", %{socket: socket} do
    push(socket, "new_game")
    push(socket, "get_state")
    assert_push("game_state", %{board: board})

    assert board == [
             [nil, nil, nil],
             [nil, nil, nil],
             [nil, nil, nil]
           ]
  end

  test "player makes a move", %{socket: socket} do
    push(socket, "new_game")
    push(socket, "player_move", 5)
    assert_push("game_state", %{})
  end

  test "ask computer to move", %{socket: socket} do
    push(socket, "new_game")
    push(socket, "computer_move")
    assert_push("game_state", %{})
  end

  test "get a new game", %{socket: socket} do
    push(socket, "new_game", "original")
    assert_push("game_state", %{board: board})

    assert board == [
             [nil, nil, nil],
             [nil, nil, nil],
             [nil, nil, nil]
           ]
  end

  test "get a new misere game", %{socket: socket} do
    push(socket, "new_game", "misere")
    assert_push("game_state", %{board: board, game_mode: game_mode})

    assert board == [
             [nil, nil, nil],
             [nil, nil, nil],
             [nil, nil, nil]
           ]

    assert game_mode == :misere
  end

  test "get a new notakto game", %{socket: socket} do
    push(socket, "new_game", "notakto")
    assert_push("game_state", %{board: board, game_mode: game_mode})

    assert board == [
             [nil, nil, nil],
             [nil, nil, nil],
             [nil, nil, nil]
           ]

    assert game_mode == :notakto
  end
end
