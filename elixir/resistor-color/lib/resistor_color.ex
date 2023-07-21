defmodule ResistorColor do
  @doc """
  Return the value of a color band
  """
  @colors ~w[black brown red orange yellow green blue violet grey white]a

  @spec code(atom) :: integer()
  def code(color) do
    Map.get(colors(), color)
  end

  defp colors() do
    @colors
    |> Enum.with_index()
    |> Map.new()
  end
end
