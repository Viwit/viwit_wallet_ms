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
    IO.inspect(conn)
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

    if Map.get(wallet1, :balance) != Map.get(wallet, :balance) do
      with {:ok, %Wallet{} = wallet} <- Module.update_wallet(wallet, a) do
        IO.puts("Transaction successfull done")
        true
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
