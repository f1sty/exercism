defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{exclude: exclude, size: size, sum: sum}) do
    variants = Enum.to_list(1..9) -- exclude
    start_combination = Enum.take(variants, size)

    end_combination =
      variants
      |> Enum.reverse()
      |> Enum.take(size)
      |> Enum.reverse()

    ranges = Enum.zip(start_combination, end_combination)

    ranges
    |> Enum.map(fn {a, b} -> a..b end)
    |> Enum.reduce(nil, fn
      range, nil ->
        for n <- range, n not in exclude, do: MapSet.new([n])

      range, numbers ->
        for number <- numbers, n <- range, n not in exclude, uniq: true, do: MapSet.put(number, n)
    end)
    |> Enum.filter(&(Enum.sum(&1) === sum && MapSet.size(&1) === size))
    |> Enum.map(&Enum.to_list/1)
  end
end
