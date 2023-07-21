defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.replace(~r/[_!.,'"\?]/, "")
    |> String.split(~r/[\s-]/, trim: true)
    |> Enum.map_join(fn <<char::utf8, _rest::binary>> -> <<char>> end)
    |> String.upcase()
  end
end
