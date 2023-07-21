defmodule StateOfTicTacToe do
  @size 3

  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    state =
      board
      |> to_chars()
      |> Enum.reduce({0, %{}}, fn symbol, {size, acc} ->
        acc = Map.put(acc, {div(size, @size), rem(size, @size)}, symbol)
        size = size + 1

        {size, acc}
      end)
      |> elem(1)
      |> Enum.group_by(fn {_k, v} -> v end, fn {k, _v} -> k end)

    cond do
      length(state["O"]) > length(state["X"]) -> {:error, "Wrong turn order: O started"}
    end
  end

  defp to_chars(raw_input) do
    raw_input
    |> String.replace(~r/\n/, "")
    |> String.split(~r/[XO\.]{1}/, trim: true, include_captures: true)
  end

  def status(parsed_board) do
  end
end
