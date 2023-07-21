defmodule PhoneNumber do
  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """
  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    case String.match?(raw, ~r/[^\(\)\-\s\d\.\+]/) do
      true ->
        {:error, "must contain digits only"}

      false ->
        digits =
          raw
          |> String.replace(~r/\D/, "")
          |> to_charlist()
          |> Enum.map(&(&1 - ?0))

        digits_qty = length(digits)

        parse(digits, digits_qty)
    end
  end

  defp parse(_digits, len) when len < 10 or len > 11, do: {:error, "incorrect number of digits"}
  defp parse([1 | digits], 11), do: parse(digits, 10)
  defp parse(_digits, 11), do: {:error, "11 digits must start with 1"}
  defp parse([0 | _], 10), do: {:error, "area code cannot start with zero"}
  defp parse([1 | _], 10), do: {:error, "area code cannot start with one"}
  defp parse([_, _, _, 0 | _], 10), do: {:error, "exchange code cannot start with zero"}
  defp parse([_, _, _, 1 | _], 10), do: {:error, "exchange code cannot start with one"}

  defp parse(digits, 10) do
    {:ok, digits |> Integer.undigits() |> to_string()}
  end
end
