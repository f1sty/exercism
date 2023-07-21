defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) do
    factors_for(number, 2, [])
  end

  defp factors_for(1, _factor, factors), do: Enum.reverse(factors)

  defp factors_for(number, factor, factors) do
    case rem(number, factor) == 0 && prime?(factor) do
      true -> factors_for(div(number, factor), factor, [factor | factors])
      false -> factors_for(number, factor + 1, factors)
    end
  end

  defp prime?(number) when number in [2, 3], do: true

  defp prime?(number) do
    Enum.reduce_while(2..floor(:math.sqrt(number)), true, fn
      divisor, true -> {:cont, rem(number, divisor) != 0}
      _divisor, false -> {:halt, false}
    end)
  end
end
