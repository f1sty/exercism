defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true
  def chain?([{a, b}]), do: a == b

  def chain?(dominoes) do
    [first | dominoes] = dominoes
    # [first | dominoes] = Enum.sort(dominoes)

    IO.inspect(%{first: first, dominoes: dominoes}, label: "dominoes")
    Enum.reduce(dominoes, [first], fn {a, b}, [{a_befor, b_befor} | rest] = acc ->
      cond do
        a_befor == a -> [{b, a} | acc]
        a_befor == b -> [{a, b} | acc]
        b_befor == b -> [{a, b}, {b_befor, a_befor} | rest]
        true -> acc
      end
    end)
  end
end
