defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(""), do: ""

  def transpose(input) do
    input
    |> String.replace(" ", "\0")
    |> String.split("\n", trim: true)
    |> then(fn input ->
      padding = input |> Enum.max_by(&String.length/1) |> String.length()

      input
      |> Enum.map(&(String.pad_trailing(&1, padding) |> String.graphemes()))
      |> Enum.zip_with(& &1)
      |> Enum.map_join("\n", fn line ->
        line
        |> Enum.join()
        |> String.trim_trailing()
      end)
    end)
    |> String.replace("\0", " ")
  end
end
