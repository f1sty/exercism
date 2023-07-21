defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    str
    |> rows()
    |> transpose()
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(""), do: []

  def saddle_points(str) do
    rows = rows(str)
    columns = columns(str)

    for x <- 0..(length(rows) - 1),
        y <- 0..(length(columns) - 1),
        height = get(x, y, rows),
        Enum.all?(Enum.at(rows, x), fn value -> value <= height end),
        Enum.all?(Enum.at(columns, y), fn value -> value >= height end) do
      {x + 1, y + 1}
    end
  end

  defp get(x, y, rows) do
    rows |> Enum.at(x) |> Enum.at(y)
  end

  defp transpose(matrix) do
    Enum.zip_with(matrix, fn column -> column end)
  end
end
