defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(_number_string, 0), do: 1

  def largest_product(number_string, size) do
    case number_string =~ ~r/^\d*$/ and size <= byte_size(number_string) and size > 0 do
      true ->
        number_string
        |> to_charlist()
        |> Enum.map(&(&1 - ?0))
        |> Enum.chunk_every(size, 1, :discard)
        |> Enum.map(&Enum.product/1)
        |> Enum.max()

      false ->
        raise ArgumentError
    end
  end
end
