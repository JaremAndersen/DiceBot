defmodule DiceBot.Response do
  alias DiceBot.Message

  def create_response(message)
      when is_struct(message, Message) and message.roll.status == :rolled do
    total = Enum.sum(message.roll.dice)
    low = Enum.min(message.roll.dice)
    high = Enum.max(message.roll.dice)
    mean = (Enum.sum(message.roll.dice) / length(message.roll.dice)) |> Float.round(2)
    net = total + message.roll.modifier

    summary = create_summary(total, message.roll.modifier, net)

    values =
      Enum.slice(message.roll.dice, 1..100)
      |> Enum.map(fn x -> Integer.to_string(x) end)
      |> Enum.join(", ")

    response = """
    #{summary}
    High: #{high}
    Low: #{low}
    Average: #{mean}
    #{values}
    """

    %Message{message | response: {:text, response}}
  end

  def create_response(message) do
    %Message{message | response: {:text, "nope"}}
  end

  defp create_summary(total, 0, _) do
    "You rolled #{total}"
  end

  defp create_summary(total, modifier, net) do
    "You rolled #{net}\n #{total} + #{modifier}"
  end
end
