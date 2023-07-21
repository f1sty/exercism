defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(dimension) do
    first_number = 1
    matrix(first_number, dimension, :forward, {0, 0}, %{})
  end

  defp matrix(current_number, dimension, _direction, _coords, matrix_map)
       when current_number > dimension * dimension do
    matrix =
      nil
      |> List.duplicate(dimension)
      |> List.duplicate(dimension)

    matrix_map
    |> Enum.sort()
    |> Enum.reduce(matrix, fn {{x, y}, number}, acc ->
      row = Enum.at(acc, y)
      row = List.replace_at(row, x, number)

      List.replace_at(acc, y, row)
    end)
  end

  defp matrix(current_number, dimension, :forward, {x, y} = coords, acc) do
    case Map.has_key?(acc, coords) or x == dimension do
      true ->
        matrix(current_number, dimension, :down, {x - 1, y + 1}, acc)

      false ->
        matrix(
          current_number + 1,
          dimension,
          :forward,
          {x + 1, y},
          Map.put(acc, coords, current_number)
        )
    end
  end

  defp matrix(current_number, dimension, :down, {x, y} = coords, acc) do
    case Map.has_key?(acc, coords) or y == dimension do
      true ->
        matrix(current_number, dimension, :backward, {x - 1, y - 1}, acc)

      false ->
        matrix(
          current_number + 1,
          dimension,
          :down,
          {x, y + 1},
          Map.put(acc, coords, current_number)
        )
    end
  end

  defp matrix(current_number, dimension, :backward, {x, y} = coords, acc) do
    case Map.has_key?(acc, coords) or x < 0 do
      true ->
        matrix(current_number, dimension, :up, {x + 1, y - 1}, acc)

      false ->
        matrix(
          current_number + 1,
          dimension,
          :backward,
          {x - 1, y},
          Map.put(acc, coords, current_number)
        )
    end
  end

  defp matrix(current_number, dimension, :up, {x, y} = coords, acc) do
    case Map.has_key?(acc, coords) or y < 0 do
      true ->
        matrix(current_number, dimension, :forward, {x + 1, y + 1}, acc)

      false ->
        matrix(
          current_number + 1,
          dimension,
          :up,
          {x, y - 1},
          Map.put(acc, coords, current_number)
        )
    end
  end
end
