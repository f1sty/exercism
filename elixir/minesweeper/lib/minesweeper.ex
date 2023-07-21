defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate([]), do: []
  def annotate([""]), do: [""]

  def annotate(board) do
    board
    |> encode()
    |> update_board()
    |> decode()
  end

  defp encode(raw_input) do
    raw_input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, board ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.into(%{}, fn {char, x} -> {{x, y}, char} end)
      |> Map.merge(board)
    end)
  end

  defp update_board(board) do
    board
    |> Map.keys()
    |> Enum.reduce(board, fn point, board -> annotate_point(board, point) end)
  end

  defp decode(board) do
    {{xs, ys}, _} = Enum.max(board)

    points =
      board
      |> Enum.sort()
      |> Enum.unzip()
      |> elem(1)

    cond do
      xs == 0 ->
        points

      ys == 0 ->
        points
        |> Enum.join()
        |> List.wrap()

      true ->
        points
        |> Enum.chunk_every(xs + 1)
        |> Enum.zip()
        |> Enum.map(fn line ->
          line
          |> Tuple.to_list()
          |> Enum.join()
        end)
    end
  end

  defp annotate_point(board, point) do
    case Map.get(board, point) != "*" do
      true ->
        point
        |> adjacent()
        |> then(&Map.take(board, &1))
        |> Map.values()
        |> Enum.count(&(&1 == "*"))
        |> maybe_put(board, point)

      false ->
        board
    end
  end

  defp maybe_put(0, board, _point), do: board
  defp maybe_put(mines, board, point), do: Map.put(board, point, to_string(mines))

  defp adjacent({x, y}) do
    for xs <- (x - 1)..(x + 1),
        ys <- (y - 1)..(y + 1),
        {xs, ys} !== {x, y},
        xs >= 0,
        ys >= 0,
        do: {xs, ys}
  end
end
