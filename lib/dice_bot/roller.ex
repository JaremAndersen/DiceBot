defmodule DiceBot.Roller do
  alias DiceBot.Roll

  def rollDice(%Roll{quantity: quantity, size: size, status: status} = roll)
      when is_struct(roll, Roll) do
    cond do
      quantity > 69420 -> %{roll | status: :oor}
      status == :error -> roll
      true -> %{roll | dice: for(_ <- 1..quantity, do: :rand.uniform(size)), status: :rolled}
    end
  end
end
