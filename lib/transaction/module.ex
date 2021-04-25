defmodule Transaction.Module do
  @moduledoc """
  The Module context.
  """

  import Ecto.Query, warn: false
  alias Transaction.Repo

  alias Transaction.Module.Wallet

  @doc """
  Returns the list of wallet.

  ## Examples

      iex> list_wallet()
      [%Wallet{}, ...]

  """
  def list_wallet do
    Repo.all(Wallet)
  end

  @doc """
  Gets a single wallet.

  Raises `Ecto.NoResultsError` if the Wallet does not exist.

  ## Examples

      iex> get_wallet!(123)
      %Wallet{}

      iex> get_wallet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wallet!(id), do: Repo.get!(Wallet, id)

  @doc """
  Creates a wallet.

  ## Examples

      iex> create_wallet(%{field: value})
      {:ok, %Wallet{}}

      iex> create_wallet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wallet(attrs \\ %{}) do
    %Wallet{}
    |> Wallet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wallet.

  ## Examples

      iex> update_wallet(wallet, %{field: new_value})
      {:ok, %Wallet{}}

      iex> update_wallet(wallet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet(%Wallet{} = wallet, attrs) do
    wallet
    |> Wallet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wallet.

  ## Examples

      iex> delete_wallet(wallet)
      {:ok, %Wallet{}}

      iex> delete_wallet(wallet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wallet(%Wallet{} = wallet) do
    Repo.delete(wallet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wallet changes.

  ## Examples

      iex> change_wallet(wallet)
      %Ecto.Changeset{data: %Wallet{}}

  """
  def change_wallet(%Wallet{} = wallet, attrs \\ %{}) do
    Wallet.changeset(wallet, attrs)
  end

  alias Transaction.Module.Trans

  @doc """
  Returns the list of transaction.

  ## Examples

      iex> list_transaction()
      [%Trans{}, ...]

  """
  def list_transaction do
    Repo.all(Trans)
  end

  @doc """
  Gets a single trans.

  Raises `Ecto.NoResultsError` if the Trans does not exist.

  ## Examples

      iex> get_trans!(123)
      %Trans{}

      iex> get_trans!(456)
      ** (Ecto.NoResultsError)

  """
  def get_trans!(id), do: Repo.get!(Trans, id)

  def get_trans_by_wallet(wid) do
    query = from(t in Trans, where: t.wallet_id == ^wid)
    Repo.all(query)
  end

  def get_trans_status(wid, stat) do
    query = from(t in Trans, where: t.wallet_id == ^wid and  t.status == ^stat)
    Repo.all(query)
  end

  def get_trans_kind(wid, kind) do
    query = from(t in Trans, where: t.wallet_id == ^wid and  t.type == ^kind)
    Repo.all(query)
  end

  def get_trans_date(wid, date) do
    query = from(t in Trans, where: t.wallet_id == ^wid and  t.date == ^date)
    Repo.all(query)
  end

  @doc """
  Creates a trans.

  ## Examples

      iex> create_trans(%{field: value})
      {:ok, %Trans{}}

      iex> create_trans(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_trans(attrs \\ %{}) do
    %Trans{}
    |> Trans.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a trans.

  ## Examples

      iex> update_trans(trans, %{field: new_value})
      {:ok, %Trans{}}

      iex> update_trans(trans, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_trans(%Trans{} = trans, attrs) do
    trans
    |> Trans.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a trans.

  ## Examples

      iex> delete_trans(trans)
      {:ok, %Trans{}}

      iex> delete_trans(trans)
      {:error, %Ecto.Changeset{}}

  """
  def delete_trans(%Trans{} = trans) do
    Repo.delete(trans)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trans changes.

  ## Examples

      iex> change_trans(trans)
      %Ecto.Changeset{data: %Trans{}}

  """
  def change_trans(%Trans{} = trans, attrs \\ %{}) do
    Trans.changeset(trans, attrs)
  end
end
