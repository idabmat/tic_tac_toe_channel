defmodule TicTacToeChannel.GameServerTest do
  use ExUnit.Case, async: true
  alias TicTacToeChannel.GameServer

  setup do
    pid = start_supervised!({GameServer, :original})
    [pid: pid]
  end

  test "getting the current game state", %{pid: pid} do
    game = GameServer.state(pid)

    assert game.board == [
             [nil, nil, nil],
             [nil, nil, nil],
             [nil, nil, nil]
           ]

    assert game.current_player in [:computer, :player1]
    assert game.winner == nil
  end

  test "dispatching player and computer moves", %{pid: pid} do
    game = GameServer.state(pid)

    if game.current_player == :player1 do
      GameServer.player_move(pid, 5)
      game = GameServer.computer_move(pid)
      assert game.current_player == :player1
      assert game.winner == nil

      assert game.board == [
               [:computer, nil, nil],
               [nil, :player1, nil],
               [nil, nil, nil]
             ]
    else
      GameServer.computer_move(pid)
      game = GameServer.player_move(pid, 2)
      assert game.current_player == :computer
      assert game.winner == nil

      assert game.board == [
               [:computer, :player1, nil],
               [nil, nil, nil],
               [nil, nil, nil]
             ]
    end
  end
end
