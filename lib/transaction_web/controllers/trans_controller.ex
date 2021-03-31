defmodule TransactionWeb.TransController do
  use TransactionWeb, :controller

  alias Transaction.Module
  alias Transaction.Module.Trans

  action_fallback TransactionWeb.FallbackController

  def index(conn, _params) do
    transaction = Module.list_transaction()
    render(conn, "index.json", transaction: transaction)
  end

  def create(conn, %{"trans" => trans_params}) do
    with {:ok, %Trans{} = trans} <- Module.create_trans(trans_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.trans_path(conn, :show, trans))
      |> render("show.json", trans: trans)
    end
  end

  def show(conn, %{"id" => id}) do
    trans = Module.get_trans!(id)
    render(conn, "show.json", trans: trans)
  end

  def update(conn, %{"id" => id, "trans" => trans_params}) do
    trans = Module.get_trans!(id)

    with {:ok, %Trans{} = trans} <- Module.update_trans(trans, trans_params) do
      render(conn, "show.json", trans: trans)
    end
  end

  def delete(conn, %{"id" => id}) do
    trans = Module.get_trans!(id)

    with {:ok, %Trans{}} <- Module.delete_trans(trans) do
      send_resp(conn, :no_content, "")
    end
  end
end