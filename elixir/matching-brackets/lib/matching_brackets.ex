defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    check_brackets(str, [])
  end

  defp check_brackets(<<ch, str::binary>>, unpaired) when ch in [?[, ?(, ?{] do
    check_brackets(str, [<<ch>> | unpaired])
  end

  defp check_brackets("]" <> str, ["[" | unpaired]), do: check_brackets(str, unpaired)
  defp check_brackets(")" <> str, ["(" | unpaired]), do: check_brackets(str, unpaired)
  defp check_brackets("}" <> str, ["{" | unpaired]), do: check_brackets(str, unpaired)

  defp check_brackets(<<ch, _str::binary>>, _unpaired) when ch in [?], ?), ?}], do: false
  defp check_brackets("", unpaired), do: Enum.empty?(unpaired)

  defp check_brackets(<<_::utf8, str::binary>>, unpaired), do: check_brackets(str, unpaired)
end
