defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> parse()
    |> Task.async_stream(fn letters -> Enum.frequencies(letters) end, max_concurrancy: workers)
    |> Enum.reduce(%{}, fn {:ok, freq_map}, acc ->
      Map.merge(acc, freq_map, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end

  defp parse(texts) do
    texts
    |> Enum.map(fn string ->
      string
      |> String.replace(~r/(*UTF8)\P{L}/, "")
      |> String.downcase()
      |> String.graphemes()
    end)
  end
end
