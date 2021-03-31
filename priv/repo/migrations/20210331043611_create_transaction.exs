defmodule Transaction.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transaction) do
      add :transaction_id, :integer
      add :wallet_id, :integer
      add :id_method_payment, :integer
      add :date, :date
      add :mount, :integer
      add :type, :integer
      add :status, :string

      timestamps()
    end

    create unique_index(:transaction, [:transaction_id])
  end
end
