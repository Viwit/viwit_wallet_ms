defmodule TransactionWeb.TransController do
  use TransactionWeb, :controller
  use PhoenixSwagger
  import Plug.Conn.Status, only: [code: 1]

  alias Transaction.Module
  alias Transaction.Module.Trans
  alias TransactionWeb.WalletController

  action_fallback TransactionWeb.FallbackController


  swagger_path :index do
    get("/transaction")
    response(code(:ok), "Success")
    summary("Get list of all transactions")
    description("For show all created transactions")
    produces("application/json")
    tag("transaction")
    # operationId("getwallets")
    paging
    # parameters ()
    response(200, "OK")
    response(400, "Not found")
  end

  swagger_path :create do
    post("/transaction")
    response(code(:ok), "Success")
    summary("Try to make a transaction")
    description("This can attempt to carry out a transaction and if it is valid it will update the specified wallet")
    produces("application/json")
    tag("transaction")
    # operationId("getwallets")
    paging
    # parameters ()
    response(200, "OK")
    response(400, "Not found")
  end
  def index(conn, _params) do
    transaction = Module.list_transaction()
    render(conn, "index.json", transaction: transaction)
  end

  def create(conn, %{"trans" => trans_params}) do
    trans_params = update_status(WalletController.update_balance(trans_params), trans_params)

    with {:ok, %Trans{} = trans} <- Module.create_trans(trans_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.trans_path(conn, :show, trans))
      |> render("show.json", trans: trans)
    end
  end

  defp update_status(what, trans_params) do
    if what do
      trans_params = Map.put_new(trans_params, "status", "Accepted")
    else
      trans_params = Map.put_new(trans_params, "status", "Rejected")
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
