defmodule Dtn.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DtnWeb.Telemetry,
      Dtn.Repo,
      {DNSCluster, query: Application.get_env(:dtn, :dns_cluster_query) || :ignore},
      {Oban,
       AshOban.config(
         Application.fetch_env!(:dtn, :ash_domains),
         Application.fetch_env!(:dtn, Oban)
       )},
      {Phoenix.PubSub, name: Dtn.PubSub},
      # Start a worker by calling: Dtn.Worker.start_link(arg)
      # {Dtn.Worker, arg},
      # Start to serve requests, typically the last entry
      DtnWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :dtn]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dtn.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DtnWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
