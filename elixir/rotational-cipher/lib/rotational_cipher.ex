defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    downcase_cipher = cipher_suite_tuple(?a..?z, shift)
    upcase_cipher = cipher_suite_tuple(?A..?Z, shift)

    text
    |> String.graphemes()
    |> Enum.map(fn letter ->
      cond do
        letter =~ ~r/\p{Ll}/ -> cipher_letter(downcase_cipher, letter)
        letter =~ ~r/\p{Lu}/ -> cipher_letter(upcase_cipher, letter)
        true -> letter
      end
    end)
    |> to_string()
  end

  defp cipher_suite_tuple(alphabet, shift) do
    alphabet_length = Enum.count(alphabet)
    start_shift = alphabet |> Enum.to_list() |> hd()

    cipher_alphabet =
      alphabet
      |> Stream.cycle()
      |> Enum.slice(shift, shift + alphabet_length)

    {cipher_alphabet, start_shift}
  end

  defp cipher_letter({cipher_alphabet, start_shift}, <<code>>) do
    Enum.at(cipher_alphabet, code - start_shift)
  end
end
