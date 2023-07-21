defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(str) do
    str
    |> normalize()
    |> format()
  end

  defp normalize(msg) do
    msg
    |> String.replace(~r/\W/, "")
    |> String.downcase()
  end

  defp format(normalized_msg) do
    msg_len = String.length(normalized_msg)

    columns =
      Enum.reduce_while(1..msg_len, {1, 1}, fn
        _, {rows, columns} when rows * columns >= msg_len -> {:halt, columns}
        _, {rows, columns} when columns - rows < 1 -> {:cont, {rows, columns + 1}}
        rows, {_, columns} -> {:cont, {rows, columns}}
      end)

    columns_regex = Regex.compile!("[[:alnum:]]{#{columns}}")

    normalized_msg
    |> String.split(columns_regex, trim: true, include_captures: true)
    |> Enum.map(fn chunk ->
      chunk
      |> String.pad_trailing(columns, " ")
      |> to_charlist()
    end)
    |> Enum.zip()
    |> Enum.map_join(" ", &Tuple.to_list/1)
  end
end
