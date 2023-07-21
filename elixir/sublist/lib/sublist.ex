defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, a), do: :equal

  def compare(a, b) do
    cond do
      contains?(a, b) -> :superlist
      contains?(b, a) -> :sublist
      true -> :unequal
    end
  end

  defp contains?(_, []), do: true
  defp contains?(a, b) do
    a
    |> Stream.chunk_every(length(b), 1, :discard)
    |> Enum.any?(&(&1 === b))
  end
end
