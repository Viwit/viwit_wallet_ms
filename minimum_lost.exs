defmodule Solution do
  def minima(lista, perdida \\ 10_000_000_000_000_000)
  def minima([_a], perdida), do: perdida

  def minima([cabeza | cola], perdida) do
    maximo = Enum.filter(cola, fn x -> x < cabeza && cabeza - x < perdida end)

    if  Enum.empty?(maximo) do
    minima(cola, perdida)
    end

    maximo = Enum.max(maximo)

  perdida =

  if cabeza - maximo < perdida do
      cabeza - maximo

    else
    perdida
    end

    minima(cola, perdida)
  end

end

_a = IO.gets("")

b =
  IO.gets("")
  |> String.split()
  |> Enum.map(fn x -> String.to_integer(x) end)

Solution.minima(b)
|> IO.puts()
