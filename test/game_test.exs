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

  test "first occurence of letter is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurence of letter is already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("test")
    { game, _tally } = Game.make_move(game, "t")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guess wins the game" do
    game = Game.new_game("test")
    { game, _tally } = Game.make_move(game, "t")
    { game, _tally } = Game.make_move(game, "e")
    { game, _tally } = Game.make_move(game, "s")
    { game, _tally } = Game.make_move(game, "t")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "bad guess is recognized" do
    game = Game.new_game("test")
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    game = Game.new_game("test")
    { game, _tally } = Game.make_move(game, "a")
    { game, _tally } = Game.make_move(game, "b")
    { game, _tally } = Game.make_move(game, "c")
    { game, _tally } = Game.make_move(game, "d")
    { game, _tally } = Game.make_move(game, "f")
    { game, _tally } = Game.make_move(game, "g")
    { game, _tally } = Game.make_move(game, "h")
    assert game.game_state == :lost
  end
end
