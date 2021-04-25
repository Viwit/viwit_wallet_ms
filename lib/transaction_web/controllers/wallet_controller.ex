defmodule TransactionWeb.WalletController do
  import Plug.Conn.Status, only: [code: 1]
  use TransactionWeb, :controller
  use PhoenixSwagger

  alias Transaction.Module
  alias Transaction.Module.Wallet

  action_fallback TransactionWeb.FallbackController

  swagger_path :index do
    get("/wallet")
    response(code(:ok), "Success")
    summary("Get list of all wallets")
    description("For show all created wallets")
    produces("application/json")
    tag("wallet")
    # operationId("getwallets")
    # parameters ()
    response(200, "OK", Schema.ref(:Wallets))
    response(400, "Not found")
  end

  swagger_path :create do
    post("/wallet")
    response(code(:ok), "Success")
    summary("Create a wallet")
    description("This can create a wallet for a logged user")
    produces("application/json")
    tag("wallet")
    # operationId("getwallets"
    # parameters ()
    response(200, "OK", Schema.ref(:Wallet))
    response(400, "Not found")
  end


  swagger_path :show do
    PhoenixSwagger.Path.get("/wallet/{id}")
    response(code(:ok), "Success")
    summary("Get wallet by its id")
     description ("For search an specific wallet")
  produces ("application/json")
  tag "wallet"
  #operationId("getwallets"
  #parameter :id, :path
  parameter :id, :path, :integer, "WalletID", required: true, example: 1
  response 200, "OK", Schema.ref(:Wallet)
  response 400, "Not found"
  end


  def swagger_definitions do
    %{
      Wallet: swagger_schema do
        title "Wallet"
        description "A wallet related to a user"
        properties do
          wallet_id :string, "Unique identifier of a wallet", required: true
          user_id :integer, "Owner of the wallet", required: true
          balance :integer, "Wallet balance"
          token :string, "Wallet token"
        end
        example %{
          wallet_id: 4,
          user_id: 5,
          balance: 10000,
          token: "DU7342w98weujafbsaxvw324734w"
        }
      end,
      Wallets: swagger_schema do
        title "Wallets"
        description "A collection of Wallets"
        type :array
        items Schema.ref(:Wallet)
      end
    }
  end


  def index(conn, _params) do
    wallet = Module.list_wallet()
    render(conn, "index.json", wallet: wallet)
  end

  def create(conn, %{"wallet" => wallet_params}) do
    wallet_params = Map.put_new(wallet_params, "balance", 0)

    with {:ok, %Wallet{} = wallet} <- Module.create_wallet(wallet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.wallet_path(conn, :show, wallet))
      |> render("show.json", wallet: wallet)
    end
  end

  def show(conn, %{"id" => id}) do
    wallet = Module.get_wallet!(id)
    render(conn, "show.json", wallet: wallet)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Module.get_wallet!(id)
    IO.inspect(wallet_params)

    with {:ok, %Wallet{} = wallet} <- Module.update_wallet(wallet, wallet_params) do
      render(conn, "show.json", wallet: wallet)
    end
  end

  def update_balance(trans_params) do
    type = Map.get(trans_params, "type")
    id = Map.get(trans_params, "wallet_id")
    wallet = Module.get_wallet!(id)
    wallet1 = update_balance_aux(type, trans_params, wallet)

    a = %{
      "balance" => Map.get(wallet1, :balance),
      "token" => Map.get(wallet1, :token),
      "user_id" => Map.get(wallet1, :user_id)
    }

    if Map.get(wallet1, :balance) != Map.get(wallet, :balance) and
         Map.get(trans_params, "mount") > 0 do
      if type == 0 and Map.get(wallet, :balance) < Map.get(trans_params, "mount") do
        IO.puts("Transaction rejected by lack of balance.")
        false
      else
        with {:ok, %Wallet{} = wallet} <- Module.update_wallet(wallet, a) do
          IO.puts("Transaction successfull done")
          true
        end
      end
    else
      IO.puts("Transaction rejected")
      false
    end
  end

  def update_balance_aux(type, trans_params, wallet) do
    if Map.get(trans_params, "token") == Map.get(wallet, :token) do
      if type == 1 do
        Map.put(wallet, :balance, Map.get(trans_params, "mount") + Map.get(wallet, :balance))
      else
        Map.put(wallet, :balance, Map.get(wallet, :balance) - Map.get(trans_params, "mount"))
      end
    else
      wallet
    end
  end

  def delete(conn, %{"id" => id}) do
    wallet = Module.get_wallet!(id)

    with {:ok, %Wallet{}} <- Module.delete_wallet(wallet) do
      send_resp(conn, :no_content, "")
    end
  end
end
