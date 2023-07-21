defmodule ResistorColorTrio do
  @bands ~w[black brown red orange yellow green blue violet grey white]a
         |> Enum.with_index()
         |> Enum.into(%{})
  @units %{
    0 => :ohms,
    1 => :kiloohms,
    2 => :megaohms,
    3 => :gigaohms
  }
  @digits 3

  @doc """
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label(colors) do
    [digit1, digit2, magnitude] = colors |> Enum.take(@digits) |> Enum.map(&Map.get(@bands, &1))
    resistance_ohms = Integer.undigits([digit1, digit2]) * 10 ** magnitude

    get_resistance_with_units(resistance_ohms, 0)
  end

  defp get_resistance_with_units(0, 0), do: {0, :ohms}

  defp get_resistance_with_units(resistance, magnitude) when rem(resistance, 1000) == 0 do
    get_resistance_with_units(div(resistance, 1000), magnitude + 1)
  end

  defp get_resistance_with_units(resistance, magnitude), do: {resistance, @units[magnitude]}
end
