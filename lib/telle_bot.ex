defmodule TelleBot.MessageTick do
  use GenServer

  require Logger

  def update do
    {status, updates} = Nadia.get_updates()

    unless updates == [] || status == :error do
      respond_to_messages(updates)
      last = List.last(updates)
      last.update_id
    end
  end

  def update(offset) do
    {status, updates} = Nadia.get_updates([{:offset, offset}])

    unless updates == [] || status == :error do
      respond_to_messages(updates)
      last = List.last(updates)
      last.update_id
    end
  end

  def respond_to_messages([]), do: nil
  def respond_to_messages([%{message: nil} | _tail]), do: nil

  def respond_to_messages([head | tail]) do
    IO.inspect(head)
    spawn(fn -> respond(head.message.chat.id, head.message.text) end)
    respond_to_messages(tail)
  end

  def respond(_id, nil), do: nil

  def respond(id, text) do
    valid =
      Regex.run(~r/^\/r (\d+)[dD](\d+)$/, text)
      |> Enum.map(&Integer.parse/1)
      |> Enum.filter(fn val -> val != :error end)
      |> IO.inspect()

    case valid do
      nil ->
        Nadia.send_message(id, "Huh?")
      [{69, _}, {69, _}] ->
        Nadia.send_sticker(
          id,
          "CAACAgIAAxkBAAIBXmEMcDrKtJLqKgyyU0ewWz0CrV-VAAJiAQACUomRI3OAqJJmT9VtIAQ"
        )

      [{420, _}, {69, _}] ->
        Nadia.send_sticker(
          id,
          "CAACAgIAAxkBAAIBV2EMbvjiuySDSJY4d58r9Vl3_JikAAJeAANSiZEj_nGk1T5n2YQgBA"
        )

        [{666, _}, {666, _}] ->
          Nadia.send_sticker(
            id,
            "CAACAgIAAxkBAAIBhWEMeX4EL-9KsNP_F32OxZf81jJbAAKmAAP3AsgPqwzk86kqxlggBA"
          )

      [{number, _}, {size, _}] when number <= 69420 ->
        dice = roll(number, size)
        prettyDice = String.replace("#{inspect(dice)}", "[", "") |> String.replace("]", "")

        total = Enum.sum(dice)
        low = Enum.min(dice)
        high = Enum.max(dice)
        mean = total / length(dice)

        output =
          "You rolled a #{total}\nHigh: #{high} \nLow: #{low} \nAverage: #{mean} \n#{prettyDice}"

        Nadia.send_message(id, output)

      _ ->
        Nadia.send_sticker(id, "CAACAgIAAxkBAAIBX2EMcRp_Ki8iUzHAQAa_dqxYR5kXAAJ8AwACbbBCAwPPVZFWz3BMIAQ")
    end
  end

  def roll(number \\ 1, size) do
    unless number <= 0 || size <= 0 do
      for _ <- 1..number, do: :rand.uniform(size)
    end
  end

  @poll_interval :timer.seconds(1)

  @spec start_link(GenServer.options()) :: GenServer.on_start()
  def start_link(options) do
    GenServer.start_link(__MODULE__, :ok, options)
  end

  def init(:ok) do
    Logger.debug("Starting bot")
    schedule_poll()
    {:ok, 0}
  end

  defp schedule_poll do
    Process.send_after(self(), :poll, @poll_interval)
  end

  def handle_info(:poll, offset) do
    next_offset = update(offset + 1) || 0
    schedule_poll()
    {:noreply, next_offset}
  end
end
