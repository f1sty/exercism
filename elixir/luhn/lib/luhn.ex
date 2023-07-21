defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    with {:ok, parsed} <- parse(number) do
      process(parsed)
    end
  end

  defp process(number) when length(number) < 2, do: false

  defp process(number) do
    [1, 2]
    |> Stream.cycle()
    |> Enum.zip(number)
    |> Enum.reduce(0, fn {factor, num}, sum ->
      check_num = factor * num
      sum + ((check_num > 9 && check_num - 9) || check_num)
    end)
    |> Integer.mod(10)
    |> Kernel.==(0)
  end

  defp parse(number) do
    number = String.replace(number, ~r/\s/, "")

    case Regex.run(~r/[^\d]/, number) do
      nil ->
        {:ok,
         number
         |> String.graphemes()
         |> Enum.map(&String.to_integer/1)
         |> Enum.reverse()}

      _ ->
        false
    end
  end
end
