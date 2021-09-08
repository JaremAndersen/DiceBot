defmodule DiceBot.Commands do
  alias DiceBot.Roll
  alias DiceBot.Roller
  alias DiceBot.Message

  def execute(message) when is_struct(message, Message) do
    %Message{message | roll: Roller.rollDice(message.roll)}
  end

  def parse(message) when is_struct(message, Message) do
    %Message{message | roll: parse(message.text)}
  end

  def parse(text) do
    Regex.run(~r/^\/r\s*(\d+)?[dD](\d+)[+]?(\d+)?$/, text) |> IO.inspect() |> parse_regex()
  end

  defp parse_regex([_, "", size]) do
    %Roll{status: :parsed, quantity: 1, size: String.to_integer(size)}
  end

  defp parse_regex([_, quantity, size]) do
    %Roll{status: :parsed, quantity: String.to_integer(quantity), size: String.to_integer(size)}
  end

  defp parse_regex([_, "", size, modifier]) do
    %Roll{
      status: :parsed,
      quantity: 1,
      size: String.to_integer(size),
      modifier: String.to_integer(modifier)
    }
  end

  defp parse_regex([_, quantity, size, modifier]) do
    %Roll{
      status: :parsed,
      quantity: String.to_integer(quantity),
      size: String.to_integer(size),
      modifier: String.to_integer(modifier)
    }
  end

  defp parse_regex(_) do
    %Roll{status: :error}
  end
end
