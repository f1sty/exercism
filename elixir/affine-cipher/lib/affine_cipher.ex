defmodule AffineCipher do
  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @chunk_size 5
  @letters ?a..?z |> Enum.with_index() |> Map.new()
  @m map_size(@letters)

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b}, message) do
    case coprime?(@m, a) do
      true ->
        fun = fn i -> Integer.mod(a * i + b, @m) end

        encrypted =
          message
          |> clean()
          |> transform(fun)
          |> Enum.chunk_every(@chunk_size)
          |> Enum.map_join(" ", &Enum.join/1)

        {:ok, encrypted}

      false ->
        {:error, "a and m must be coprime."}
    end
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    case coprime?(@m, a) do
      true ->
        fun = fn y -> Integer.mod(mmi(a, @m) * (y - b), @m) end

        decrypted =
          encrypted
          |> clean()
          |> transform(fun)
          |> Enum.join()

        {:ok, decrypted}

      false ->
        {:error, "a and m must be coprime."}
    end
  end

  defp coprime?(m, a), do: Integer.gcd(m, a) == 1

  defp transform(data, fun) do
    data
    |> String.graphemes()
    |> Enum.map(&transform_fn(fun, &1))
  end

  defp transform_fn(fun, <<char>>) do
    case Map.get(@letters, char) do
      nil ->
        <<char>>

      n ->
        <<n |> fun.() |> letter_by_idx()>>
    end
  end

  # [Modular Multiplicative Inverse](https://en.wikipedia.org/wiki/Modular_multiplicative_inverse)
  defp mmi(a, x \\ 1, m) do
    case Integer.mod(a * x, m) == 1 do
      true -> x
      false -> mmi(a, x + 1, m)
    end
  end

  defp clean(message) do
    message
    |> String.downcase()
    |> String.replace(~r/[^[:alnum:]]/, "")
  end

  defp letter_by_idx(idx) do
    @letters
    |> Enum.find(fn {_, v} -> v == idx end)
    |> elem(0)
  end
end
