defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(category, dice) do
    do_score(category, Enum.frequencies(dice))
  end

  defp do_score(:ones, dice_freq), do: Map.get(dice_freq, 1, 0)
  defp do_score(:twos, dice_freq), do: 2 * Map.get(dice_freq, 2, 0)
  defp do_score(:threes, dice_freq), do: 3 * Map.get(dice_freq, 3, 0)
  defp do_score(:fours, dice_freq), do: 4 * Map.get(dice_freq, 4, 0)
  defp do_score(:fives, dice_freq), do: 5 * Map.get(dice_freq, 5, 0)
  defp do_score(:sixes, dice_freq), do: 6 * Map.get(dice_freq, 6, 0)

  defp do_score(:full_house, dice_freq) do
    case dice_freq |> Map.values() |> Enum.sort() do
      [2, 3] -> Enum.reduce(dice_freq, 0, fn {k, v}, sum -> sum + k * v end)
      _ -> 0
    end
  end

  defp do_score(:four_of_a_kind, dice_freq) do
    case Enum.find(dice_freq, fn {_, v} -> v >= 4 end) do
      {n, _} -> n * 4
      nil -> 0
    end
  end

  defp do_score(:little_straight, dice_freq) do
    case dice_freq |> Map.keys() |> Enum.sort() do
      [1, 2, 3, 4, 5] -> 30
      _ -> 0
    end
  end

  defp do_score(:big_straight, dice_freq) do
    case dice_freq |> Map.keys() |> Enum.sort() do
      [2, 3, 4, 5, 6] -> 30
      _ -> 0
    end
  end

  defp do_score(:choice, dice_freq) do
    Enum.reduce(dice_freq, 0, fn {k, v}, sum -> sum + k * v end)
  end

  defp do_score(:yacht, dice_freq) do
    case map_size(dice_freq) do
      1 -> 50
      _ -> 0
    end
  end
end
