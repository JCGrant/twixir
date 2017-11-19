defmodule Twixir do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok, client} = ExIrc.start_client!

    channel_name = Application.get_env(:twixir, :chan)

    children = [
      worker(ConnectionHandler, [client]),
      worker(LoginHandler, [client, ["##{channel_name}"]]),
      worker(TwixirHandler, [client])
    ]

    opts = [strategy: :one_for_one, name: Twixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
