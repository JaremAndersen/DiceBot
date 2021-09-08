defmodule DiceBot.MessageTick do
  use GenServer
  alias DiceBot.Messages

  require Logger

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
    messages = Messages.get(offset) |> Messages.respond()

    last = Enum.at(messages, 0)

    next_offset =
      case last do
        nil ->
          0

        _ ->
          last.update_id + 1
      end

    schedule_poll()
    {:noreply, next_offset}
  end
end
