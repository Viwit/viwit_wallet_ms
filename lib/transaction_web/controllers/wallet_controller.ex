defmodule TransactionWeb.WalletController do
  use TransactionWeb, :controller

  alias Transaction.Module
  alias Transaction.Module.Wallet

  action_fallback TransactionWeb.FallbackController

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
    IO.inspect conn
    wallet = Module.get_wallet!(id)
    render(conn, "show.json", wallet: wallet)
  end


  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Module.get_wallet!(id)

    with {:ok, %Wallet{} = wallet} <- Module.update_wallet(wallet, wallet_params) do
      render(conn, "show.json", wallet: wallet)
    end
  end

  def update_balance(conn, trans_params) do
   type = Map.get(trans_params,"type")
    id = Map.get(trans_params,"wallet_id")
    wallet = Module.get_wallet!(id)
if type == 1 do
  wallet = Map.put(wallet_params, :balance, (Map.get(trans_params,"mount")+Map.get(wallet_params,:balance)) )
else
  wallet = Map.put(wallet_params, :balance, (Map.get(trans_params,"mount")+Map.get(wallet_params,:balance)))
end
update(conn, wallet_params)

  end

  def delete(conn, %{"id" => id}) do
    wallet = Module.get_wallet!(id)

    with {:ok, %Wallet{}} <- Module.delete_wallet(wallet) do
      send_resp(conn, :no_content, "")
    end
  end
end
