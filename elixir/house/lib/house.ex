defmodule House do
  @insertions [
    "",
    "the malt that lay in",
    "the rat that ate",
    "the cat that killed",
    "the dog that worried",
    "the cow with the crumpled horn that tossed",
    "the maiden all forlorn that milked",
    "the man all tattered and torn that kissed",
    "the priest all shaven and shorn that married",
    "the rooster that crowed in the morn that woke",
    "the farmer sowing his corn that kept",
    "the horse and the hound and the horn that belonged to"
  ]
  @sentence_start "This is"
  @sentence_end "the house that Jack built."

  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    (start - 1)..(stop - 1)
    |> Enum.map_join(fn verse_number ->
      lines =
        @insertions
        |> Enum.slice(0..verse_number)
        |> Enum.reverse()
        |> Enum.join(" ")

      <<@sentence_start, ?\s, lines::binary, @sentence_end, ?\n>>
    end)
  end
end
