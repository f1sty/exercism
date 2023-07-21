defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """

  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    max_gap = (letter - ?A) * 2 - 1
    build_shape(letter, max_gap, &String.duplicate(" ", &1), [])
  end

  defp build_shape(?@, _max_gap, _helper_fun, lines) do
    [_ | bottom_half] = Enum.reverse(lines)
    Enum.join(lines ++ bottom_half)
  end

  defp build_shape(letter, max_gap, dup, lines) do
    gap = (letter - ?A) * 2 - 1
    padding = div(max_gap - gap, 2)

    line =
      case gap <= 0 do
        true ->
          dup.(padding) <> <<letter>> <> dup.(padding)

        false ->
          dup.(padding) <> <<letter>> <> dup.(gap) <> <<letter>> <> dup.(padding)
      end
      |> Kernel.<>("\n")

    build_shape(letter - 1, max_gap, dup, [line | lines])
  end
end
