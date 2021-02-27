defmodule Multibulls.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MultibullsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Multibulls.PubSub},
      # Start the Endpoint (http/https)
      MultibullsWeb.Endpoint,
      # Start a worker by calling: Multibulls.Worker.start_link(arg)
      # {Multibulls.Worker, arg}
      Multibulls.BackupAgent,
      Multibulls.GameSup,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Multibulls.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MultibullsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
