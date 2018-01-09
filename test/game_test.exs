defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert Enum.all?(game.letters, fn l -> Regex.match?(~r/[a-z]/, l) end)
  end

  test "state isn't changed for our won or lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game()
             |> Map.put(:game_state, state)
      assert {^game, _} = Game.make_move(game, "x")
    end
  end

end
