defmodule TwixirHandler do
  @moduledoc """
  Handle twitch messages
  """
  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    ExIrc.Client.add_handler client, self()
    {:ok, socket} = :gen_tcp.connect('localhost', 8000, [:binary, active: false])
    {:ok, [client, socket]}
  end

  def handle_info({:joined, channel}, state) do
    debug "Joined #{channel}"
    {:noreply, state}
  end

  def handle_info({:received, message, sender, _channel}, state = [_client, socket]) do
    from = sender.nick
    debug "#{from}: #{message}"
    {ok, data} = parse_message(message)
    if ok == :ok do
      send_data(data, socket)
    end
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  def parse_message(message) do
    case Regex.run(~r/!\s*(\d+)\s*(\d+)\s*(\w+)/, message) do
      [_, x, y, color] -> {:ok, {x, y, color}}
      _ -> {:nomatch, nil}
    end
  end

  def send_data({x, y, color}, socket) do
    :gen_tcp.send(socket, "#{x} #{y} #{color}\r\n")
    debug "#{x} #{y} #{color}"
  end

  defp debug(msg) do
    IO.puts IO.ANSI.yellow() <> msg <> IO.ANSI.reset()
  end
end
