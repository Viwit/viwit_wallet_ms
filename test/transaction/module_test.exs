defmodule Transaction.ModuleTest do
  use Transaction.DataCase

  alias Transaction.Module

  describe "wallet" do
    alias Transaction.Module.Wallet

    @valid_attrs %{balance: 42, token: "some token", user_id: 42, wallet_id: 42}
    @update_attrs %{balance: 43, token: "some updated token", user_id: 43, wallet_id: 43}
    @invalid_attrs %{balance: nil, token: nil, user_id: nil, wallet_id: nil}

    def wallet_fixture(attrs \\ %{}) do
      {:ok, wallet} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Module.create_wallet()

      wallet
    end

    test "list_wallet/0 returns all wallet" do
      wallet = wallet_fixture()
      assert Module.list_wallet() == [wallet]
    end

    test "get_wallet!/1 returns the wallet with given id" do
      wallet = wallet_fixture()
      assert Module.get_wallet!(wallet.id) == wallet
    end

    test "create_wallet/1 with valid data creates a wallet" do
      assert {:ok, %Wallet{} = wallet} = Module.create_wallet(@valid_attrs)
      assert wallet.balance == 42
      assert wallet.token == "some token"
      assert wallet.user_id == 42
      assert wallet.wallet_id == 42
    end

    test "create_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Module.create_wallet(@invalid_attrs)
    end

    test "update_wallet/2 with valid data updates the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{} = wallet} = Module.update_wallet(wallet, @update_attrs)
      assert wallet.balance == 43
      assert wallet.token == "some updated token"
      assert wallet.user_id == 43
      assert wallet.wallet_id == 43
    end

    test "update_wallet/2 with invalid data returns error changeset" do
      wallet = wallet_fixture()
      assert {:error, %Ecto.Changeset{}} = Module.update_wallet(wallet, @invalid_attrs)
      assert wallet == Module.get_wallet!(wallet.id)
    end

    test "delete_wallet/1 deletes the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{}} = Module.delete_wallet(wallet)
      assert_raise Ecto.NoResultsError, fn -> Module.get_wallet!(wallet.id) end
    end

    test "change_wallet/1 returns a wallet changeset" do
      wallet = wallet_fixture()
      assert %Ecto.Changeset{} = Module.change_wallet(wallet)
    end
  end

  describe "transaction" do
    alias Transaction.Module.Trans

    @valid_attrs %{date: ~D[2010-04-17], id_method_payment: 42, mount: 42, status: "some status", transaction_id: 42, type: 42, wallet_id: 42}
    @update_attrs %{date: ~D[2011-05-18], id_method_payment: 43, mount: 43, status: "some updated status", transaction_id: 43, type: 43, wallet_id: 43}
    @invalid_attrs %{date: nil, id_method_payment: nil, mount: nil, status: nil, transaction_id: nil, type: nil, wallet_id: nil}

    def trans_fixture(attrs \\ %{}) do
      {:ok, trans} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Module.create_trans()

      trans
    end

    test "list_transaction/0 returns all transaction" do
      trans = trans_fixture()
      assert Module.list_transaction() == [trans]
    end

    test "get_trans!/1 returns the trans with given id" do
      trans = trans_fixture()
      assert Module.get_trans!(trans.id) == trans
    end

    test "create_trans/1 with valid data creates a trans" do
      assert {:ok, %Trans{} = trans} = Module.create_trans(@valid_attrs)
      assert trans.date == ~D[2010-04-17]
      assert trans.id_method_payment == 42
      assert trans.mount == 42
      assert trans.status == "some status"
      assert trans.transaction_id == 42
      assert trans.type == 42
      assert trans.wallet_id == 42
    end

    test "create_trans/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Module.create_trans(@invalid_attrs)
    end

    test "update_trans/2 with valid data updates the trans" do
      trans = trans_fixture()
      assert {:ok, %Trans{} = trans} = Module.update_trans(trans, @update_attrs)
      assert trans.date == ~D[2011-05-18]
      assert trans.id_method_payment == 43
      assert trans.mount == 43
      assert trans.status == "some updated status"
      assert trans.transaction_id == 43
      assert trans.type == 43
      assert trans.wallet_id == 43
    end

    test "update_trans/2 with invalid data returns error changeset" do
      trans = trans_fixture()
      assert {:error, %Ecto.Changeset{}} = Module.update_trans(trans, @invalid_attrs)
      assert trans == Module.get_trans!(trans.id)
    end

    test "delete_trans/1 deletes the trans" do
      trans = trans_fixture()
      assert {:ok, %Trans{}} = Module.delete_trans(trans)
      assert_raise Ecto.NoResultsError, fn -> Module.get_trans!(trans.id) end
    end

    test "change_trans/1 returns a trans changeset" do
      trans = trans_fixture()
      assert %Ecto.Changeset{} = Module.change_trans(trans)
    end
  end
end
