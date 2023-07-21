defmodule Username do
  @spec sanitize(charlist) :: charlist
  def sanitize(username) do
    username
    |> substitute()
    |> Enum.filter(fn letter -> letter in ?a..?z or letter == ?_ end)
  end

  defp substitute(username) do
    username
    |> Enum.map(fn letter ->
      case letter do
        ?ä -> 'ae'
        ?ö -> 'oe'
        ?ü -> 'ue'
        ?ß -> 'ss'
        letter -> letter
      end
    end)
    |> List.flatten()
  end
end
