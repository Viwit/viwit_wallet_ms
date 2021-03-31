defmodule Transaction.Repo.Migrations.CreateWallet do
  use Ecto.Migration

  def change do
    create table(:wallet) do
      add :user_id, :integer
      add :balance, :integer
      add :token, :string

      timestamps()
    end

  end
end
