defmodule Scrabble do
  @score_table %{
    ~w[A E I O U L N R S T] => 1,
    ~w[D G] => 2,
    ~w[B C M P] => 3,
    ~w[F H V W Y] => 4,
    ~w[K] => 5,
    ~w[J X] => 8,
    ~w[Q Z] => 10
  }

  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    word
    |> String.upcase()
    |> String.replace(~r/\s/, "")
    |> String.graphemes()
    |> Enum.map(&Enum.find_value(@score_table, fn {letters, points} -> &1 in letters && points end))
    |> Enum.sum()
  end
end
