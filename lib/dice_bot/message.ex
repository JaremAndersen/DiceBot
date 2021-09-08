defmodule DiceBot.Message do
  alias DiceBot.Roll
  defstruct id: 0, text: "", update_id: 0, roll: %Roll{}, response: {}
end
