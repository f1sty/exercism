defmodule BirdCount do
  def today([]), do: nil
  def today([count | _]), do: count

  def increment_day_count([]), do: [1]
  def increment_day_count([count | list]), do: [count + 1 | list]

  def has_day_without_birds?([0 | _list]), do: true
  def has_day_without_birds?([]), do: false
  def has_day_without_birds?([_count | list]), do: has_day_without_birds?(list)

  def total(list), do: total(list, 0)

  defp total([], sum), do: sum

  defp total([count | list], sum) do
    total(list, sum + count)
  end

  def busy_days(list), do: busy_days(list, 0)

  defp busy_days([], fivers), do: fivers

  defp busy_days([count | list], fivers) do
    fivers = if count >= 5, do: fivers + 1, else: fivers
    busy_days(list, fivers)
  end
end
