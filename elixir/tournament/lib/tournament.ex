defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    header = "Team                           | MP |  W |  D |  L |  P"

    input
    |> Enum.map(&String.split(&1, ";", trim: true))
    |> Enum.reduce(%{}, &update_table(&2, &1))
    |> Enum.map(fn {team, data} ->
      data =
        data
        |> Map.values()
        |> Enum.sum()
        |> then(&Map.put(data, :mp, &1))
        |> Map.put(:p, data.w * 3 + data.d)

      {team, data}
    end)
    |> Enum.sort_by(fn {_team, %{p: points}} -> points end, :desc)
    |> Enum.map_join("", fn {team, %{p: p, w: w, l: l, d: d, mp: mp}} ->
      team = String.pad_trailing(team, 30)
      data = Enum.map([mp, w, d, l, p], &padding(" |", &1, 3))

      ["\n", team | data]
    end)
    |> then(&(header <> &1))
  end

  defp padding(prefix, value, count) do
    prefix <> String.pad_leading("#{value}", count)
  end

  defp update_table(table, [home_team, away_team, "draw"]) do
    table
    |> Map.update(home_team, %{w: 0, d: 1, l: 0}, fn team -> %{team | d: team.d + 1} end)
    |> Map.update(away_team, %{w: 0, d: 1, l: 0}, fn team -> %{team | d: team.d + 1} end)
  end

  defp update_table(table, [home_team, away_team, "win"]) do
    table
    |> Map.update(home_team, %{w: 1, d: 0, l: 0}, fn team -> %{team | w: team.w + 1} end)
    |> Map.update(away_team, %{w: 0, d: 0, l: 1}, fn team -> %{team | l: team.l + 1} end)
  end

  defp update_table(table, [home_team, away_team, "loss"]) do
    update_table(table, [away_team, home_team, "win"])
  end

  defp update_table(table, _wrong_data), do: table
end
