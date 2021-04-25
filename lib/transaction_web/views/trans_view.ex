defmodule TransactionWeb.TransView do
  use TransactionWeb, :view
  alias TransactionWeb.TransView

  def render("index.json", %{transaction: transaction}) do
    %{data: render_many(transaction, TransView, "trans.json")}
  end

  def render("show.json", %{trans: trans}) do
    %{data: render_one(trans, TransView, "trans.json")}
  end

  def render("trans.json", %{trans: trans}) do
    %{
      id: trans.id,
      wallet_id: trans.wallet_id,
      id_method_payment: trans.id_method_payment,
      mount: trans.mount,
      type: trans.type,
      status: trans.status,
      date:
        DateTime.from_naive!(trans.inserted_at, "Etc/UTC")
        |> DateTime.to_string()
        |> String.slice(0..9)
    }
  end
end
