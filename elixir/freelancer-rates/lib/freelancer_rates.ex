defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    hourly_rate * 8.0
  end

  def apply_discount(before_discount, discount) do
    discount = before_discount * (discount / 100)
    before_discount - discount
  end

  def monthly_rate(hourly_rate, discount) do
    before_discount = daily_rate(hourly_rate) * 22

    before_discount
    |> apply_discount(discount)
    |> ceil()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    daily_rate =
      hourly_rate
      |> daily_rate()
      |> apply_discount(discount)

    Float.floor(budget / daily_rate, 1)
  end
end
