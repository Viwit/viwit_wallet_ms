defmodule TransactionWeb.Router do
  use TransactionWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TransactionWeb do
    pipe_through :api
    resources "/wallet", WalletController, except: [:delete, :new, :edit, :update]
    resources "/transaction", TransController, except: [:update, :delete, :new, :edit]
    get "/transaction/wallet/:wallet_id", TransController, :show_by_wallet
    get "/transaction/wallet/:wallet_id/:status", TransController, :show_by_state
    get "/transaction/wallet/:wallet_id/type/:type", TransController, :show_by_kind
    get "/transaction/wallet/:wallet_id/:date", TransController, :show_by_date

  end

  def swagger_info do
    %{
      schemes: ["http", "https"],
      swagger: "2.0",
      info: %{
        version: "1.0",
        title: "Wallet-Transaction API",
        description: "This is a microservice exposed as an API Rest coded in Elixir",
        termsOfService: "http://swagger.io/terms/",
        contact: %{
          name: "Edisson Prieto",
          email: "edprietov@unal.edu.co"
        }
      },
      host: "localhost:4100",
      basePath: "/",
      consumes: ["application/json"],
      produces: ["application/json"],
      tags: [
        %{name: "wallet", description: "Everything related to wallet's management",
        externalDocs: %{
          description: "Path",
          url: "http://localhost:4100/wallet"
        }},
        %{name: "transaction", description: "Everything related to transaction's management",
        externalDocs: %{
          description: "Path",
          url: "http://localhost:4100/transaction"
        }},
      ],
      externalDocs: %{
        description: "Find out more about Swagger",
        url: "http://swagger.io"
      }
    }
  end

end
