defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, rails) do
    posotions = Enum.to_list(1..rails) ++ Enum.to_list((rails - 1)..2)
    router = Stream.cycle(posotions)
    acc = List.duplicate("", rails)

    str
    |> String.graphemes()
    |> Enum.zip(router)
    |> Enum.reduce(acc, fn {letter, position}, lines ->
      List.update_at(lines, position - 1, &<<&1 <> letter>>)
    end)
    |> Enum.join()
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, rails) do
    first_rail_len = ceil(String.length(str) / (2 * (rails - 1)))
    middle_chunks_len = (first_rail_len - 1) * 2
    {first_rail, rails} = String.split_at(str, first_rail_len)
    chunks = rails |> String.graphemes() |> Enum.chunk_every(middle_chunks_len)

    [String.graphemes(first_rail) | chunks]
  end
end
