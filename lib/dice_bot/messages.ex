defmodule DiceBot.Messages do
  alias DiceBot.Message
  alias DiceBot.Commands
  alias DiceBot.Response
  alias DiceBot.Meems

  def get do
    case Nadia.get_updates() do
      {:ok, updates} ->
        parse(updates, [])

      {:error, _} ->
        nil
    end
  end

  def get(offset) do
    case Nadia.get_updates([{:offset, offset}]) do
      {:ok, updates} ->
        parse(updates, [])

      {:error, _} ->
        nil
    end
  end

  def ack(id) do
    Nadia.get_updates([{:offset, id + 1}])
  end

  def send(message) do
    case message.response do
      {:text, val} -> Nadia.send_message(message.id, val)
      {:sticker, val} -> Nadia.send_sticker(message.id, val)
    end

    message
  end

  def respond_all([]), do: nil

  def respond_all([head | tail]) do
    spawn(fn -> respond(head) end)
    respond_all(tail)
  end

  def respond(messages) when is_list(messages) do
    respond_all(messages)
    messages
  end

  def respond(message) when is_struct(message, Message) do
    message
    |> Commands.parse()
    |> Commands.execute()
    |> Response.create_response()
    |> Meems.meemify()
    |> IO.inspect()
    |> send()
  end

  def parse([], messages), do: messages

  def parse([%{message: nil, update_id: update_id} | tail], messages) do
    ack(update_id)
    parse(tail, messages)
  end

  def parse([head | tail], messages) do
    messages = [
      %Message{
        id: head.message.chat.id,
        text: head.message.text,
        update_id: head.update_id
      }
      | messages
    ]

    # spawn(fn -> respond(head.message.chat.id, head.message.text) end)
    parse(tail, messages)
  end
end
