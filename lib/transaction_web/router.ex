defmodule TransactionWeb.Router do
  use TransactionWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TransactionWeb do
    pipe_through :api
    resources "/wallet", WalletController, except: [:delete, :new, :edit, :update]
    resources "/transaction", TransController, except: [:update, :delete, :new, :edit]
  end
end
