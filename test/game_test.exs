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
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do
    game = Game.new_game()
           |> Game.make_move("x")
    assert game.game_state != :already_used
  end

  test "second occurence of letter is already used" do
    game = Game.new_game()
           |> Game.make_move("x")
    assert game.game_state != :already_used
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("test")
           |> Game.make_move("t")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guess wins the game" do
    game = Game.new_game("test")
           |> Game.make_move("t")
           |> Game.make_move("e")
           |> Game.make_move("s")
           |> Game.make_move("t")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "bad guess is recognized" do
    game = Game.new_game("test")
           |> Game.make_move("x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    game = Game.new_game("test")
           |> Game.make_move("a")
           |> Game.make_move("b")
           |> Game.make_move("c")
           |> Game.make_move("d")
           |> Game.make_move("f")
           |> Game.make_move("g")
           |> Game.make_move("h")
    assert game.game_state == :lost
  end
end
