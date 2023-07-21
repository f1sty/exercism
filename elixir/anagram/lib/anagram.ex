defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    base = String.downcase(base)
    candidates = Enum.reject(candidates, &(String.downcase(&1) == base))
    letters = String.graphemes(base)

    Enum.filter(candidates, fn candidate ->
      candidate_letters = candidate |> String.downcase() |> String.graphemes()

      candidate_letters -- letters == [] and letters -- candidate_letters == []
    end)
  end
end
