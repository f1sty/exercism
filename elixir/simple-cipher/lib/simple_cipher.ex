defmodule SimpleCipher do
  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext` by
  shifting it by the corresponding letter in the alphabet shifted by the number
  of letters represented by the `key` character, repeating the `key` if it is
  shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and mapping it
  to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet of the `key`
  character in the same position. If the `key` is shorter than the `plaintext`,
  repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """
  def encode(plaintext, key \\ generate_key())
  def encode(plaintext, key) when is_binary(key), do: encode(plaintext, to_charlist(key))

  def encode(plaintext, key) do
    key
    |> Stream.cycle()
    |> Enum.zip_with(to_charlist(plaintext), fn k, p -> rem(p + k - 2 * ?a, 26) + ?a end)
    |> to_string()
  end

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key) when is_binary(key), do: decode(ciphertext, to_charlist(key))

  def decode(ciphertext, key) do
    key
    |> Stream.cycle()
    |> Enum.zip_with(to_charlist(ciphertext), fn k, c -> Integer.mod(c - k, 26) + ?a end)
    |> to_string()
  end

  @doc """
  Generate a random key of a given length. It should contain lowercase letters only.
  """
  def generate_key(length \\ 100) do
    for <<ch <- :crypto.strong_rand_bytes(length)>>, into: "", do: <<rem(ch, 26) + ?a>>
  end
end
