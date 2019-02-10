defmodule TlcApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      TlcApp.Repo,
      # Start the endpoint when the application starts
      TlcApp.Web.Endpoint
      # Starts a worker by calling: TlcApp.Worker.start_link(arg)
      # {TlcApp.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TlcApp.Supervisor]
    case Supervisor.start_link(children, opts) do
      {:ok, _} = res ->
        TlcApp.Accounts.create_first_user()

        res
        x -> x
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TlcApp.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
