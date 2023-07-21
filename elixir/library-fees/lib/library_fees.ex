defmodule LibraryFees do
  def datetime_from_string(string) do
    NaiveDateTime.from_iso8601!(string)
  end

  def before_noon?(%{hour: hour}), do: hour < 12

  def return_date(checkout_datetime) do
    return_after_days = if before_noon?(checkout_datetime), do: 28, else: 29

    checkout_datetime
    |> NaiveDateTime.to_date()
    |> Date.add(return_after_days)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    case Date.compare(planned_return_date, actual_return_datetime) do
      :lt -> Date.diff(actual_return_datetime, planned_return_date)
      _ -> 0
    end
  end

  def monday?(datetime), do: Date.day_of_week(datetime) == 1

  def calculate_late_fee(checkout, return, rate) do
    checkout = datetime_from_string(checkout)
    return = datetime_from_string(return)
    planned_return = return_date(checkout)
    days_late = days_late(planned_return, return)

    fees = days_late * rate * if monday?(return), do: 0.5, else: 1

    floor(fees)
  end
end
