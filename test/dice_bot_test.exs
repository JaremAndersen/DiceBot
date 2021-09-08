defmodule DiceBotTest do
  use ExUnit.Case
  alias DiceBot.Roll

  test "rolls dice" do
    roll = %Roll{quantity: 5, size: 1}
    assert DiceBot.Roller.rollDice(roll).dice == [1, 1, 1, 1, 1]
  end
end
