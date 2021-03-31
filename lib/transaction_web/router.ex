defmodule TransactionWeb.Router do
  use TransactionWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TransactionWeb do
    pipe_through :api
    resources "/wallet", WalletController, except: [:new, :edit]
    resources "/transaction", TransController, except: [:new, :edit, :update, :delete]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TransactionWeb.Telemetry
    end
  end
end