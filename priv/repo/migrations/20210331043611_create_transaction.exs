defmodule Transaction.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transaction) do
      add :wallet_id, :integer
      add :id_method_payment, :integer
      add :mount, :integer
      add :type, :integer
      add :status, :string
      add :token, :string

      timestamps()
    end

  end
end
