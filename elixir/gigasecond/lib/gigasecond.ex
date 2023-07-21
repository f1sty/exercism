defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          {{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}
  def from({date, time}) do
    date = Date.from_erl!(date)
    time = Time.from_erl!(time)

    date_time =
      date
      |> DateTime.new!(time)
      |> DateTime.add(1_000_000_000)

    date = Date.to_erl(date_time)
    time = Time.to_erl(date_time)

    {date, time}
  end
end
