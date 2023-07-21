defmodule DNA do
  def encode_nucleotide(code_point) do
    case code_point do
      ?\s -> 0b0000
      ?A -> 0b0001
      ?C -> 0b0010
      ?G -> 0b0100
      ?T -> 0b1000
    end
  end

  def decode_nucleotide(encoded_code) do
    case encoded_code do
      0b0000 -> ?\s
      0b0001 -> ?A
      0b0010 -> ?C
      0b0100 -> ?G
      0b1000 -> ?T
    end
  end

  def encode(dna), do: encode(dna, <<>>)

  defp encode([], encoded_dna), do: encoded_dna

  defp encode([nucleotide | dna], encoded_dna) do
    nucleotide = encode_nucleotide(nucleotide)

    encode(dna, <<encoded_dna::bitstring, nucleotide::4>>)
  end

  def decode(dna), do: decode(dna, [])

  defp decode(<<>>, decoded_dna), do: Enum.reverse(decoded_dna)

  defp decode(<<nucleotide::4, dna::bitstring>>, decoded_dna) do
    nucleotide = decode_nucleotide(nucleotide)

    decode(dna, [nucleotide | decoded_dna])
  end
end
