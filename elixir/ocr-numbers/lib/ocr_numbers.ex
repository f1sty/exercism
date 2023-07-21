defmodule OcrNumbers do
  @ocr_table %{
    ["   ", "  |", "  |"] => "1",
    [" _ ", " _|", "|_ "] => "2",
    [" _ ", " _|", " _|"] => "3",
    ["   ", "|_|", "  |"] => "4",
    [" _ ", "|_ ", " _|"] => "5",
    [" _ ", "|_ ", "|_|"] => "6",
    [" _ ", "  |", "  |"] => "7",
    [" _ ", "|_|", "|_|"] => "8",
    [" _ ", "|_|", " _|"] => "9",
    [" _ ", "| |", "|_|"] => "0"
  }

  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    cond do
      Enum.any?(input, &(String.length(&1) |> rem(3) != 0)) -> {:error, "invalid column count"}
      input |> Enum.count() |> rem(4) != 0 -> {:error, "invalid line count"}
      true -> process(input, [])
    end
  end

  defp process([], digits) do
    {:ok, digits |> Enum.reverse() |> Enum.join(",")}
  end

  defp process([e0, e1, e2, _e3 | input], digits) do
    digits_line =
      [e0, e1, e2]
      |> Enum.map(&String.split(&1, ~r/.{3}/, trim: true, include_captures: true))
      |> Enum.zip_with(& &1)
      |> Enum.map(&Map.get(@ocr_table, &1, "?"))

    process(input, [digits_line | digits])
  end
end
