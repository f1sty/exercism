defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    for number <- 0..(limit - 1),
        factor <- factors,
        factor > 0,
        rem(number, factor) == 0,
        uniq: true do
      number
    end
    |> Enum.sum()
  end
end
