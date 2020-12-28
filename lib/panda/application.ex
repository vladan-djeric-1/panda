defmodule Panda.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Panda.Worker.start_link(arg)
      {Plug.Cowboy,
       scheme: :http, plug: Panda.Router, options: [port: Application.get_env(:panda, :port)]},
      {Cachex, name: Application.fetch_env!(:panda, :cache_name)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Panda.Supervisor]
    Logger.info("Starting application...")
    Supervisor.start_link(children, opts)
  end
end
