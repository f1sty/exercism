defmodule PigLatin do
  @vowels ~w[a e i o u]
  @consonants ~w[b c d f g h j k l m n p q r s t v w x y z]

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.downcase()
    |> String.split(" ", trim: true)
    |> Enum.map(&pigify_word/1)
    |> Enum.join(" ")
  end

  @spec pigify_word(String.t(), String.t()) :: String.t()
  defp pigify_word(word, suffix \\ "ay") do
    word
    |> String.graphemes()
    |> Enum.reduce_while({"", word}, fn
      letter, {leading_consonants, <<_::utf8, trailing::binary>> = rest}
      when letter in @vowels ->
        if String.last(leading_consonants) == "q" and letter == "u" do
          {:cont, {leading_consonants <> letter, trailing}}
        else
          {:halt, rest <> leading_consonants <> suffix}
        end

      letter, {"", <<_::utf8, next::utf8, trailing::binary>>}
      when letter in ~w[x y] and <<next>> in @consonants ->
        {:halt, letter <> <<next>> <> trailing <> suffix}

      letter, {"", <<_::utf8, trailing::binary>>} when letter in ~w[x y] ->
        {:cont, {letter, trailing}}

      letter, {leading_consonants, rest} when letter == "y" ->
        {:halt, rest <> leading_consonants <> suffix}

      letter, {leading_consonants, <<_::utf8, trailing::binary>>}
      when letter in @consonants ->
        {:cont, {leading_consonants <> letter, trailing}}
    end)
  end
end
