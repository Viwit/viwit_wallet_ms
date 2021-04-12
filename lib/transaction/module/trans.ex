defmodule Transaction.Module.Trans do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transaction" do
    field :id_method_payment, :integer
    field :mount, :integer
    field :status, :string
    field :type, :integer
    field :wallet_id, :integer
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(trans, attrs) do
    trans
    |> cast(attrs, [:wallet_id, :id_method_payment, :mount, :type, :status, :token])
    |> validate_required([:wallet_id, :mount, :type, :token])
  end
end
