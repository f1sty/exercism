defmodule Lasagna do
  @spec expected_minutes_in_oven() :: pos_integer
  def expected_minutes_in_oven() do
    40
  end

  @spec remaining_minutes_in_oven(non_neg_integer) :: non_neg_integer
  def remaining_minutes_in_oven(minutes) do
    expected_minutes_in_oven() - minutes
  end

  @spec preparation_time_in_minutes(pos_integer) :: pos_integer
  def preparation_time_in_minutes(layers_qty) do
    layers_qty * 2
  end

  @spec total_time_in_minutes(pos_integer, non_neg_integer) :: pos_integer
  def total_time_in_minutes(layers_qty, minutes_in_oven) do
    preparation_time_in_minutes(layers_qty) + minutes_in_oven
  end

  @spec alarm() :: String.t()
  def alarm() do
    "Ding!"
  end
end
