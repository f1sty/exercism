defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> transpose()
    |> format()
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher), do: transpose(cipher)

  defp transpose(string) do
    transpose_map = transpose_map()

    string
    |> String.downcase()
    |> String.replace(~r/\W/, "")
    |> String.graphemes()
    |> Enum.map(fn letter -> Map.get(transpose_map, letter, letter) end)
    |> Enum.join()
  end

  defp format(string) do
    string
    |> String.split(~r/[[:alnum:]]{5}/, include_captures: true, trim: true)
    |> Enum.join(" ")
  end

  defp transpose_map() do
    alphabet = for letter <- ?a..?z, do: <<letter>>

    alphabet
    |> Enum.reverse()
    |> Enum.zip(alphabet)
    |> Enum.into(%{})
  end
end
