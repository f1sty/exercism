defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) when is_binary(string) do
    string
    |> String.graphemes()
    |> encode("")
  end

  defp encode(graphemes, previous_letter, subsequent_count \\ 1, encoded \\ "")

  defp encode([], last, count, encoded) do
    encoded <> format_count(count) <> last
  end

  defp encode([letter | graphemes], letter, count, encoded) do
    encode(graphemes, letter, count + 1, encoded)
  end

  defp encode([letter | graphemes], previous_letter, count, encoded) do
    encoded = encoded <> format_count(count) <> previous_letter

    encode(graphemes, letter, 1, encoded)
  end

  defp format_count(count), do: (count == 1 && "") || to_string(count)

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    string
    |> String.split(~r/[\pL|\s]/, include_captures: true, trim: true)
    |> Enum.reduce({1, ""}, fn token, {times, decoded} ->
      case Integer.parse(token) do
        {times, _} -> {times, decoded}
        :error -> {1, decoded <> String.duplicate(token, times)}
      end
    end)
    |> elem(1)
  end
end
