defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list, list) :: list
  def flatten(list, acc \\ [])
  def flatten([], acc), do: Enum.reverse(acc)

  def flatten([elem | list], acc) when is_list(elem) do
    acc = flatten(elem, acc) |> Enum.reverse()
    flatten(list, acc)
  end

  def flatten([nil | list], acc), do: flatten(list, acc)
  def flatten([elem | list], acc), do: flatten(list, [elem | acc])
end
