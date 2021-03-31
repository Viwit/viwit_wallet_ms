defmodule Transaction.Module.Trans do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transaction" do
    field :id_method_payment, :integer
    field :mount, :integer
    field :status, :string
    field :transaction_id, :integer
    field :type, :integer
    field :wallet_id, :integer

    timestamps()
  end

  @doc false
  def changeset(trans, attrs) do
    trans
    |> cast(attrs, [:transaction_id, :wallet_id, :id_method_payment, :date, :mount, :type, :status])
    |> validate_required([:transaction_id, :wallet_id, :id_method_payment, :date, :mount, :type, :status])
    |> unique_constraint(:transaction_id)
  end
end
