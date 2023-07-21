defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """
  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    start_index = floor(tuple_size(numbers) / 2)
    search(numbers, key, start_index, 0)
  end

  defp search(numbers, key, index, last_visited)
       when index >= 0 and index < tuple_size(numbers) do
    value = elem(numbers, index)

    case key == value do
      true ->
        {:ok, index}

      false ->
        sign = (key > value && 1) || -1
        next_index = index + sign * ceil(abs(index - last_visited) / 2)

        if last_visited == next_index,
          do: :not_found,
          else: search(numbers, key, next_index, index)
    end
  end

  defp search(_numbers, _key, _index, _last_visited), do: :not_found
end
