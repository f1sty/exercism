defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""

  def recite([last | _] = strings) do
    last = ["And all for the want of a #{last}.\n"]

    strings
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [word1, word2] -> "For want of a #{word1} the #{word2} was lost." end)
    |> Enum.concat(last)
    |> Enum.join("\n")
  end
end
