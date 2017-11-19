defmodule ConnectionHandler do
  @moduledoc """
  Connects to Twitch IRC
  """
  defmodule State do
    defstruct host: "irc.twitch.tv",
              port: 6667,
              pass: Application.get_env(:twixir, :pass),
              nick: Application.get_env(:twixir, :nick),
              user: Application.get_env(:twixir, :nick),
              name: Application.get_env(:twixir, :nick),
              client: nil
  end

  def start_link(client, state \\ %State{}) do
    GenServer.start_link(__MODULE__, [%{state | client: client}])
  end

  def init([state]) do
    ExIrc.Client.add_handler state.client, self()
    ExIrc.Client.connect! state.client, state.host, state.port
    {:ok, state}
  end

  def handle_info({:connected, server, port}, state) do
    debug "Connected to #{server}:#{port}"
    ExIrc.Client.logon state.client, state.pass, state.nick, state.user, state.name
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp debug(msg) do
    IO.puts IO.ANSI.yellow() <> msg <> IO.ANSI.reset()
  end
end
