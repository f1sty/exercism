defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    sentence = sentence |> String.replace(~r/\W/, "") |> String.downcase()

    for <<ch <- sentence>>, reduce: %{} do
      acc -> Map.update(acc, ch, 1, &(&1 + 1))
    end
    |> Enum.all?(fn {_, count} -> count == 1 end)
  end
end
