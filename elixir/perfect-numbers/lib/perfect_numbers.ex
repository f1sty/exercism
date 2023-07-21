defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number <= 0,
    do: {:error, "Classification is only possible for natural numbers."}

  def classify(1), do: {:ok, :deficient}
  def classify(number) do
    aliquot_sum = aliquot_sum(number)

    type =
      cond do
        aliquot_sum == number -> :perfect
        aliquot_sum > number -> :abundant
        aliquot_sum < number -> :deficient
      end

    {:ok, type}
  end

  defp aliquot_sum(number) do
    for divisor <- 1..(number - 1), rem(number, divisor) == 0, reduce: 0 do
      sum -> sum + divisor
    end
  end
end
