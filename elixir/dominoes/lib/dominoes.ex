defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true

  def chain?([domino | dominoes]) do
    chain?(domino, dominoes)
  end

  defp chain?({edge, edge}, []), do: true

  defp chain?({first, last}, pile) do
    Stream.map(pile, fn
      {edge1, ^last} = domino -> chain?({first, edge1}, List.delete(pile, domino))
      {^last, edge2} = domino -> chain?({first, edge2}, List.delete(pile, domino))
      _ -> false
    end)
    |> Enum.any?()
  end
end
