defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """
  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer
  def maximum_value(items, maximum_weight) do
    maximum_value(items, maximum_weight, [])
  end

  defp maximum_value([], _maximum_weight, []), do: 0
  defp maximum_value([], _maximum_weight, values), do: List.last(values)

  defp maximum_value([item | items], maximum_weight, prev_values) do
    values =
      for capacity <- 1..maximum_weight do
        prev_value = get_at(prev_values, capacity - 1)

        current_value =
          if item.weight <= capacity do
            item.value + get_at(prev_values, capacity - item.weight - 1)
          else
            0
          end

        Enum.max([prev_value, current_value])
      end

    maximum_value(items, maximum_weight, values)
  end

  defp get_at(_list, i) when i < 0, do: 0
  defp get_at(list, i), do: Enum.at(list, i, 0)
end
