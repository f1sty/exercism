defmodule Darts do
  @type position :: {number, number}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @radius 10.0

  @spec score(position) :: integer
  def score({x, y}) do
    r = :math.sqrt(x ** 2 + y ** 2)
    distance_to_score(r)
  end

  defp distance_to_score(distance) when distance > @radius, do: 0
  defp distance_to_score(distance) when distance <= @radius and distance > @radius / 2, do: 1
  defp distance_to_score(distance) when distance <= @radius / 2 and distance > 1.0, do: 5
  defp distance_to_score(distance) when distance <= 1.0 and distance >= 0.0, do: 10
end
