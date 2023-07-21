defmodule Clock do
  defstruct hour: 0, minute: 0

  @minutes_per_day 24 * 60
  @type t :: %__MODULE__{}

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: t()
  def new(hour, minute) do
    total_minutes = Integer.mod(minute + hour * 60, @minutes_per_day)
    hour = div(total_minutes, 60)
    minute = Integer.mod(total_minutes, 60)

    struct(__MODULE__, hour: hour, minute: minute)
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(t(), integer) :: t()
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end

  defimpl String.Chars, for: Clock do
    def to_string(%Clock{hour: hour, minute: minute}) do
      "#{pad(hour)}:#{pad(minute)}"
    end

    defp pad(num), do: num |> Integer.to_string() |> String.pad_leading(2, "0")
  end
end
