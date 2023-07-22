defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  import Bitwise

  @spec encode(integers :: [integer]) :: binary
  def encode(integers), do: encode(integers, <<>>)

  defp encode([], encoded), do: encoded
  defp encode([0 | integers], encoded), do: encode(integers, <<encoded::bytes, 0>>)

  defp encode([number | integers], encoded) do
    number_bit_size = count_octets(number) * 7

    <<init::bits-size(number_bit_size - 7), last::bits-size(7)>> =
      <<number::size(number_bit_size)>>

    new =
      <<for(<<part::7 <- init>>, into: <<>>, do: <<1::1, part::7>>)::bits, 0::1,
        last::bits-size(7)>>

    encode(integers, <<encoded::bytes, new::bytes>>)
  end

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes), do: decode(bytes, [], [])

  defp decode(<<>>, [], integers), do: {:ok, Enum.reverse(integers)}
  defp decode(<<>>, _carry, _integers), do: {:error, "incomplete sequence"}

  defp decode(<<0::1, bits::7, _bytes::bytes>>, _carry, _integers) when bits > 127 do
    {:error, "incomplete sequence"}
  end

  defp decode(<<0::1, bits::7, bytes::bytes>>, carry, integers) do
    integer =
      carry
      |> Enum.with_index(1)
      |> Enum.reduce(0, fn {num, exp}, acc -> acc ||| num <<< (7 * exp) end)
      |> bor(bits)

    decode(bytes, [], [integer | integers])
  end

  defp decode(<<1::1, bits::7, bytes::bytes>>, carry, integers) do
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
end
