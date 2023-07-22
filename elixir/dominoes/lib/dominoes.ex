defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true

  def chain?(dominoes) do
    len = length(dominoes)

    dominoes
    |> Enum.map(&chain?(List.delete(dominoes, &1), [&1], len))
    |> Enum.any?()
  end

  def chain?([], chain, len) do
    {first, last} = edges(chain)

    first == last and length(chain) == len
  end

  def chain?([{left, right} = domino], chain, _len) do
    {edge1, edge2} = edges(chain)

    cond do
      edge1 == right -> [domino | chain]
      edge2 == left -> chain ++ [domino]
      true -> chain
    end
  end

  def chain?(left_dominoes, chain, len) do
    {edge1, edge2} = edges(chain)
    {{left, right} = domino, rest} = List.pop_at(left_dominoes, 0)

    {left_dominoes, chain} =
      cond do
        edge1 == right -> {rest, [domino | chain]}
        edge2 == left -> {rest, chain ++ [domino]}
        true -> {rest ++ [domino], chain}
      end

    dbg(left_dominoes)
    dbg(chain)
    Process.sleep(1000)
    chain?(left_dominoes, chain, len)
  end

  defp edges([{a, b}]), do: {a, b}

  defp edges(chain) do
    {a, _} = List.first(chain)
    {_, b} = List.last(chain)

    {a, b}
  end
end
