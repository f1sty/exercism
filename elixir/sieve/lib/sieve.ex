defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(1), do: []

  def primes_to(limit) do
    primes(Enum.to_list(2..limit), [])
  end

  defp primes([number], primes), do: Enum.reverse([number | primes])

  defp primes([number | candidates], primes) do
    limit = List.last(candidates)
    to_remove = Enum.to_list((number * 2)..limit//number)
    candidates = candidates -- to_remove

    primes(candidates, [number | primes])
  end
end
