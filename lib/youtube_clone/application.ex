defmodule YoutubeClone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      YoutubeClone.Repo,
      # Start the Telemetry supervisor
      YoutubeCloneWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: YoutubeClone.PubSub},
      # Start the Endpoint (http/https)
      YoutubeCloneWeb.Endpoint
      # Start a worker by calling: YoutubeClone.Worker.start_link(arg)
      # {YoutubeClone.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: YoutubeClone.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    YoutubeCloneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
