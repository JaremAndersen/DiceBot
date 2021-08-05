defmodule TelleBot.MessageTick do
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

  def respond_to_messages(updates) do
    [head | tail] = updates

    unless head.message == nil do
      try do
        respond(head.message.chat.id, head.message.text)
      rescue
        RuntimeError -> IO.puts("there was an error")
      end
    end

    unless tail == [] do
      respond_to_messages(tail)
    end
  end

  def respond(id, text) do
    if text =~ "/r" and (text =~ "d" or text =~ "D") do
      [number, size] =
        String.downcase(text)
        |> String.replace("/r", "")
        |> String.trim()
        |> String.split("d")
        |> Enum.map(fn val -> String.trim(val) end)

      unless number === "" || size == "" do
        dice = roll(String.to_integer(number), String.to_integer(size))

        unless dice == nil do
          prettyDice = String.replace("#{inspect(dice)}", "[", "") |> String.replace("]", "")
          total = Enum.sum(dice)
          output = "You rolled a #{total}\n#{prettyDice}"
          Nadia.send_message(id, output)
        end
      end
    end
  end

  def roll(number \\ 1, size) do
    unless number <= 0 || size <= 0 do
      for _ <- 1..number, do: :rand.uniform(size)
    end
  end

  def tick(offset \\ 0) do
    offset = update(offset + 1) || 0
    Process.sleep(1000)
    tick(offset)
  end
end
