defmodule Transaction.Repo do
  use Ecto.Repo,
    otp_app: :transaction,
    adapter: Ecto.Adapters.Postgres


end
