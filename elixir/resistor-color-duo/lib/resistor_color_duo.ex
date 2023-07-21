defmodule ResistorColorDuo do
  @bands ~w[black brown red orange yellow green blue violet grey white]a
         |> Enum.with_index()
         |> Enum.into(%{})
  @digits 2

  @doc """
  Calculate a resistance value from two colors
  """
  @spec value(colors :: [atom]) :: integer
  def value(colors) do
    colors
    |> Enum.take(@digits)
    |> Enum.map(&Map.get(@bands, &1))
    |> Integer.undigits()
  end
end
