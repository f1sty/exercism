defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(0), do: raise "no zeroth prime"
  def nth(1), do: 2
  def nth(2), do: 3

  def nth(count) do
    Stream.iterate(4, &(&1 + 1))
    |> Stream.filter(&prime?/1)
    |> Enum.at(count - 3)
  end

  defp prime?(number) do
    Enum.reduce_while(2..floor(:math.sqrt(number)), true, fn
      divisor, true -> {:cont, rem(number, divisor) != 0}
      _divisor, false -> {:halt, false}
    end)
  end

  # defp nth(count, primes) when count === length(primes), do: hd(primes)

  # defp nth(count, [last | _] = primes) do
  #   candidate = last + 1
  #   primes = if prime?(candidate), do: [candidate | primes], else: primes

  #   nth(count, primes)
  # end

  # defp prime?(number) do
  #   with false <- perfect_power?(number),
  #        r <- find_smallest_r(number),
  #        false <- composite?(number, r) do
  #     number <= r
  #   end
  # end

  # defp perfect_power?(number) do
  #   a = for b <- 2..floor(:math.log2(number)), do: :math.pow(number, 1 / b)

  #   Enum.any?(a, fn x ->
  #     case Float.ratio(x) do
  #       {_numerator, 1} -> true
  #       _other -> false
  #     end
  #   end)
  # end

  # def find_smallest_r(number) do
  #   max_k = floor(:math.log2(number) ** 2.0)
  #   max_r = Enum.max(3..floor(:math.log2(number) ** 5.0))

  #   r_candidates = for r <- 2..(max_r - 1), coprime(r, number), do: r

  #   Enum.find(r_candidates, fn r ->
  #     Enum.reduce_while(1..max_k, true, fn k, acc ->
  #       case rem(number ** k, r) == 1 or rem(number ** k, r) == 0 do
  #         false -> {:cont, acc}
  #         true -> {:halt, false}
  #       end
  #     end)
  #   end)
  # end

  # defp composite?(number, r) do
  #   Enum.reduce_while(r..2, false, fn a, acc ->
  #     gcd = gcd(a, number)

  #     case gcd > 1 and gcd < number do
  #       true -> {:halt, true}
  #       false -> {:cont, acc}
  #     end
  #   end)
  # end

  # defp coprime(number1, number2) do
  #   gcd(number1, number2) === 1
  # end

  # defp gcd(0, v), do: v
  # defp gcd(u, 0), do: u

  # defp gcd(u, v) when rem(u, 2) == 0 and rem(v, 2) == 0 do
  #   u = div(u, 2)
  #   v = div(v, 2)

  #   2 * gcd(u, v)
  # end

  # defp gcd(u, v) when rem(u, 2) == 0 and rem(v, 2) != 0, do: gcd(div(u, 2), v)
  # defp gcd(u, v) when rem(u, 2) != 0 and rem(v, 2) == 0, do: gcd(u, div(v, 2))
  # defp gcd(u, v), do: gcd(abs(u - v), Enum.min([u, v]))
end
