defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    Stream.resource(
      fn -> [1] end,
      fn rows ->
        middle =
          rows
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.map(&Enum.sum/1)

        {[rows], [1 | middle] ++ [1]}
      end,
      fn rows -> rows end
    )
    |> Enum.take(num)
  end
end
