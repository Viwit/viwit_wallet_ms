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
    # parameters ()
    response(200, "OK", Schema.ref(:Transactions))
    response(400, "Not found")
  end

  swagger_path :create do
    post("/transaction")
    response(code(:ok), "Success")
    summary("Try to make a transaction")

    description(
      "This can attempt to carry out a transaction and if it is valid it will update the specified wallet"
    )

    produces("application/json")
    tag("transaction")
    # operationId("getwallets")
    # parameters ()
    response(200, "OK", Schema.ref(:Transaction))
    response(400, "Not found")
  end

  def swagger_definitions do
    %{
      Transaction:
        swagger_schema do
          title("Transaction")
          description("A transaction made by an user")

          properties do
            transaction_id(:string, "Unique identifier of a transaction", required: true)
            user_id(:integer, "User who make a transaction", required: true)
            mount(:integer, "Amount of transaction")
            token(:string, "To verify wallet correspondence")
            type(:integer, "Identify the kind of transaction")

            id_method_payment(
              :integer,
              "In case of wallet recharging is used to identify methos user for payment"
            )
          end

          example(%{
            transaction_id: 10,
            user_id: 1,
            mount: 3000,
            token: "algo",
            type: 1,
            id_method_payment: 1
          })
        end,
      Transactions:
        swagger_schema do
          title("Transactions")
          description("A collection of transactions")
          type(:array)
          items(Schema.ref(:Transaction))
        end
    }
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

  def show_by_wallet(conn, %{"wallet_id" => wallet_id}) do
    transaction = Module.get_trans_by_wallet(wallet_id)
    render(conn, "index.json", transaction: transaction)
  end

  def show_by_state(conn, %{"wallet_id" => wallet_id, "status" => status}) do
    transaction = Module.get_trans_status(wallet_id, status)
    render(conn, "index.json", transaction: transaction)
  end

  def show_by_kind(conn, %{"wallet_id" => wallet_id, "type" => type}) do
    transaction = Module.get_trans_kind(wallet_id, type)
    render(conn, "index.json", transaction: transaction)
  end

  def show_by_date(conn, %{"wallet_id" => wallet_id, "date" => date}) do
    transaction = Module.get_trans_kind(wallet_id, date)
    render(conn, "index.json", transaction: transaction)
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
