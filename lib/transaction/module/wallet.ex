defmodule Transaction.Module.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallet" do
    field :balance, :integer
    field :token, :string
    field :user_id, :integer


    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs,[:user_id, :balance, :token])
    |> validate_required([:user_id, :token])
  end
end
