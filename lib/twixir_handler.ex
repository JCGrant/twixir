defmodule TwixirHandler do
  @moduledoc """
  Handle twitch messages
  """
  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    ExIrc.Client.add_handler client, self()
    {:ok, client}
  end

  def handle_info({:joined, channel}, client) do
    debug "Joined #{channel}"
    {:noreply, client}
  end

  def handle_info({:received, message, sender, _channel}, _state) do
    from = sender.nick
    debug "#{from}: #{message}"
    {:noreply, nil}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp debug(msg) do
    IO.puts IO.ANSI.yellow() <> msg <> IO.ANSI.reset()
  end
end
