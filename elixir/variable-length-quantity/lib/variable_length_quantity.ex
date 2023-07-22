defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  import Bitwise

  @spec encode(integers :: [integer]) :: binary
  def encode(integers) do
    encode(integers, <<>>)
  end

  defp encode([], encoded), do: encoded

  defp encode([0 | integers], encoded), do: encode(integers, <<encoded::bitstring, 0::8>>)

  defp encode([number | integers], encoded) do
    octets_qty = count_octets(number)
    number = <<number::size(octets_qty * 7)>>

    new_encoded =
      for <<part::7 <- number>>, into: <<>> do
        <<1::1, part::7>>
      end
      |> reset_lsb_bit()

    encode(integers, <<encoded::bitstring, new_encoded::bitstring>>)
  end

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes) do
    decode(bytes, [], [])
  end

  defp decode(<<>>, [], integers) do
    {:ok, Enum.reverse(integers)}
  end

  defp decode(<<>>, _carry, _integers) do
    {:error, "incomplete sequence"}
  end

  defp decode(<<0::1, bits::7, _bytes::bitstring>>, _carry, _integers) when bits > 127 do
    {:error, "incomplete sequence"}
  end

  defp decode(<<0::1, bits::7, bytes::bitstring>>, carry, integers) do
    integer =
      carry
      |> Enum.with_index(1)
      |> Enum.reduce(0, fn {num, exp}, acc -> acc ||| num <<< (7 * exp) end)
      |> bor(bits)

    decode(bytes, [], [integer | integers])
  end

  defp decode(<<1::1, bits::7, bytes::bitstring>>, carry, integers) do
    carry = [bits | carry]

    decode(bytes, carry, integers)
  end

  defp count_octets(number) do
    number
    |> :math.log2()
    |> floor()
    |> div(7)
    |> Kernel.+(1)
  end

  defp reset_lsb_bit(almost_vlq) do
    init = :binary.part(almost_vlq, {0, byte_size(almost_vlq) - 1})
    <<_::1, last::7>> = :binary.part(almost_vlq, {byte_size(almost_vlq), -1})

    <<init::bitstring, 0::1, last::7>>
  end
end
