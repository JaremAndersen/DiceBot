defmodule DiceBot.Meems do
  alias DiceBot.Message

  def meemify(message) do
    %{quantity: quantity, size: size, status: status} = message.roll

    sticker =
      cond do
        quantity == 69 && size == 69 ->
          "CAACAgIAAxkBAAIBXmEMcDrKtJLqKgyyU0ewWz0CrV-VAAJiAQACUomRI3OAqJJmT9VtIAQ"

        quantity == 420 && size == 69 ->
          "CAACAgIAAxkBAAIBV2EMbvjiuySDSJY4d58r9Vl3_JikAAJeAANSiZEj_nGk1T5n2YQgBA"

        quantity == 666 && size == 666 ->
          "CAACAgIAAxkBAAIBhWEMeX4EL-9KsNP_F32OxZf81jJbAAKmAAP3AsgPqwzk86kqxlggBA"

        status == :oor ->
          "CAACAgIAAxkBAAIBX2EMcRp_Ki8iUzHAQAa_dqxYR5kXAAJ8AwACbbBCAwPPVZFWz3BMIAQ"

        true ->
          false
      end

    if sticker do
      %Message{message | response: {:sticker, sticker}}
    else
      message
    end
  end
end
