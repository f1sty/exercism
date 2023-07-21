defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    isbn = String.replace(isbn, ~r/[\s-]/, "")

    String.match?(isbn, ~r/^\d{9}[\d|X]$/) and
      isbn
      |> to_charlist()
      |> Enum.map(fn
        ?X -> 10
        ch -> ch - ?0
      end)
      |> Enum.zip(10..1)
      |> Enum.map(fn {x, y} -> x * y end)
      |> Enum.sum()
      |> rem(11)
      |> Kernel.==(0)
  end
end
