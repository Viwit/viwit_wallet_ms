defmodule TransactionWeb.WalletView do
  use TransactionWeb, :view
  alias TransactionWeb.WalletView

  def render("index.json", %{wallet: wallet}) do
    %{data: render_many(wallet, WalletView, "wallet.json")}
  end

  def render("show.json", %{wallet: wallet}) do
    %{data: render_one(wallet, WalletView, "wallet.json")}
  end

  def render("wallet.json", %{wallet: wallet}) do
    %{id: wallet.id,

      user_id: wallet.user_id,
      balance: wallet.balance,
      token: wallet.token}
  end
end
