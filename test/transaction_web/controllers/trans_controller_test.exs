defmodule TransactionWeb.TransControllerTest do
  use TransactionWeb.ConnCase

  alias Transaction.Module
  alias Transaction.Module.Trans

  @create_attrs %{
    date: ~D[2010-04-17],
    id_method_payment: 42,
    mount: 42,
    status: "some status",
    transaction_id: 42,
    type: 42,
    wallet_id: 42
  }
  @update_attrs %{
    date: ~D[2011-05-18],
    id_method_payment: 43,
    mount: 43,
    status: "some updated status",
    transaction_id: 43,
    type: 43,
    wallet_id: 43
  }
  @invalid_attrs %{date: nil, id_method_payment: nil, mount: nil, status: nil, transaction_id: nil, type: nil, wallet_id: nil}

  def fixture(:trans) do
    {:ok, trans} = Module.create_trans(@create_attrs)
    trans
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transaction", %{conn: conn} do
      conn = get(conn, Routes.trans_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create trans" do
    test "renders trans when data is valid", %{conn: conn} do
      conn = post(conn, Routes.trans_path(conn, :create), trans: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.trans_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => "2010-04-17",
               "id_method_payment" => 42,
               "mount" => 42,
               "status" => "some status",
               "transaction_id" => 42,
               "type" => 42,
               "wallet_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.trans_path(conn, :create), trans: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update trans" do
    setup [:create_trans]

    test "renders trans when data is valid", %{conn: conn, trans: %Trans{id: id} = trans} do
      conn = put(conn, Routes.trans_path(conn, :update, trans), trans: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.trans_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => "2011-05-18",
               "id_method_payment" => 43,
               "mount" => 43,
               "status" => "some updated status",
               "transaction_id" => 43,
               "type" => 43,
               "wallet_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, trans: trans} do
      conn = put(conn, Routes.trans_path(conn, :update, trans), trans: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete trans" do
    setup [:create_trans]

    test "deletes chosen trans", %{conn: conn, trans: trans} do
      conn = delete(conn, Routes.trans_path(conn, :delete, trans))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.trans_path(conn, :show, trans))
      end
    end
  end

  defp create_trans(_) do
    trans = fixture(:trans)
    %{trans: trans}
  end
end
