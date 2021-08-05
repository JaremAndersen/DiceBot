defmodule TelleBotTest do
  use ExUnit.Case
  doctest TelleBot

  test "greets the world" do
    assert TelleBot.hello() == :world
  end
end
