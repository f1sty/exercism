defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1)
  def generate(max_factor, min_factor) when min_factor > max_factor, do: raise(ArgumentError)

  def generate(max_factor, min_factor) do
    for x <- min_factor..max_factor,
        y <- x..max_factor,
        mul = x * y,
        palindrome?(mul),
        reduce: %{} do
      acc ->
        value = [x, y]
        Map.update(acc, mul, [value], fn factors -> [value | factors] end)
    end
  end

  defp palindrome?(number) do
    number
    |> Integer.digits()
    |> then(&(&1 == Enum.reverse(&1)))
  end
end
