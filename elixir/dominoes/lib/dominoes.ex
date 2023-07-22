defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true

  def chain?(dominoes) do
    dominoes
    |> Enum.map(&chain?(&1, List.delete(dominoes, &1)))
    |> Enum.any?()
  end

  def chain?({edge, edge}, []), do: true

  def chain?(edges, pile) do
    with update_instructions <- maybe_find_matching_domino(pile, edges),
         {edges, pile} <- maybe_update_edges(update_instructions) do
      chain?(edges, pile)
    end
  end

  defp maybe_find_matching_domino(pile, {first, last} = edges) do
    pile
    |> Enum.with_index()
    |> Enum.reduce(:none, fn {{edge1, edge2} = domino, idx}, update_instructions ->
      cond do
        first == edge2 -> {:prepend, domino, edges, pile, idx}
        last == edge1 -> {:append, domino, edges, pile, idx}
        first == edge1 -> {:prepend, rotate(domino), edges, pile, idx}
        last == edge2 -> {:append, rotate(domino), edges, pile, idx}
        true -> update_instructions
      end
    end)
  end

  defp maybe_update_edges(:none), do: false

  defp maybe_update_edges({:prepend, {first, _}, {_, last}, pile, idx}) do
    edges = {first, last}
    pile = List.delete_at(pile, idx)

    {edges, pile}
  end

  defp maybe_update_edges({:append, {_, last}, {first, _}, pile, idx}) do
    edges = {first, last}
    pile = List.delete_at(pile, idx)

    {edges, pile}
  end

  defp rotate({first, last}), do: {last, first}
end
