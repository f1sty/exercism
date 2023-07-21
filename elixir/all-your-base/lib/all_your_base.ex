defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(digits, input_base, output_base) do
    cond do
      output_base < 2 ->
        {:error, "output base must be >= 2"}

      input_base < 2 ->
        {:error, "input base must be >= 2"}

      Enum.any?(digits, fn digit -> digit < 0 or digit >= input_base end) ->
        {:error, "all digits must be >= 0 and < input base"}

      digits == [] ->
        {:ok, [0]}

      true ->
        decimal =
          Enum.reduce_while(digits, {length(digits) - 1, 0}, fn
            digit, {0, sum} -> {:halt, sum + digit}
            digit, {power, sum} -> {:cont, {power - 1, sum + digit * input_base ** power}}
          end)

        digits = decimal_to_base(decimal, output_base, [])

        {:ok, digits}
    end
  end

  defp decimal_to_base(0, _base, []), do: [0]
  defp decimal_to_base(0, _base, digits), do: digits

  defp decimal_to_base(decimal, base, digits) do
    digit = rem(decimal, base)
    decimal = div(decimal, base)

    decimal_to_base(decimal, base, [digit | digits])
  end
end
