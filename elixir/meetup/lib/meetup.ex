defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @day_numbers_map %{
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) do
    start_date = Date.new!(year, month, 1)
    days_in_month = Date.days_in_month(start_date)
    end_date = Date.new!(year, month, days_in_month)

    start_date
    |> Date.range(end_date)
    |> Enum.filter(&(Date.day_of_week(&1) == @day_numbers_map[weekday]))
    |> then(fn days ->
      case schedule do
        :first -> hd(days)
        :second -> Enum.at(days, 1)
        :third -> Enum.at(days, 2)
        :fourth -> Enum.at(days, 3)
        :last -> List.last(days)
        :teenth -> Enum.find(days, &(&1.day in 13..19))
      end
    end)
  end
end
