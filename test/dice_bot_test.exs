defmodule DiceBotTest do
  use ExUnit.Case
  doctest DiceBot.MessageTick

  test "rolls dice" do
    assert DiceBot.MessageTick.roll(5, 1) == [1, 1, 1, 1, 1]
  end

  test ""
end
