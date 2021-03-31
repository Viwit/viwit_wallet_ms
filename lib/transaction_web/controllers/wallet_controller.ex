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

    with {:ok, %Wallet{} = wallet} <- Module.update_wallet(wallet, wallet_params) do
      render(conn, "show.json", wallet: wallet)
    end
  end

  def delete(conn, %{"id" => id}) do
    wallet = Module.get_wallet!(id)

    with {:ok, %Wallet{}} <- Module.delete_wallet(wallet) do
      send_resp(conn, :no_content, "")
    end
  end
end
