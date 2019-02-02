defmodule TlcApp.Repo do
  use Ecto.Repo,
    otp_app: :tlc_app,
    adapter: Ecto.Adapters.Postgres
end
