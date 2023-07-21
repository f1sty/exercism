defmodule Say do
  @digits_names Enum.zip(0..9, ~w[zero one two three four five six seven eight nine]) |> Map.new()
  @teens_names Enum.zip(
                 10..19,
                 ~w[ten eleven twelve thirteen fourteen sixteen seventeen eighteen nineteen]
               )
               |> Map.new()
  @tenths_names Enum.zip(
                  20..90//10,
                  ~w[twenty thirty forty fifty sixty seventy eighty ninety]
                )
                |> Map.new()

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number >= 0 and number <= 9, do: {:ok, @digits_names[number]}
  def in_english(number) when number >= 10 and number <= 19, do: {:ok, @teens_names[number]}

  def in_english(number) when number >= 20 and number <= 99 do
    with last_digit <- rem(number, 10),
         {:ok, last_digit_name} <- in_english(last_digit),
         tenth <- number - last_digit do
      case last_digit == 0 do
        true -> {:ok, @tenths_names[tenth]}
        false -> {:ok, @tenths_names[tenth] <> "-" <> last_digit_name}
      end
    end
  end

  def in_english(number) when number >= 100 and number <= 999 do
    with {:ok, hundreds} <- div(number, 100) |> in_english(),
         {:ok, tenths} <- rem(number, 100) |> in_english() do
      case tenths == "zero" do
        true -> {:ok, hundreds <> " hundred"}
        false -> {:ok, hundreds <> " hundred " <> tenths}
      end
    end
  end

  def in_english(number) when number > 0 and number <= 999_999_999_999 do
    number
    |> Integer.digits()
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.map(fn number -> number |> Enum.reverse() |> Integer.undigits() end)
    |> parse()
  end

  def in_english(_number), do: {:error, "number is out of range"}

  defp parse(unparsed_number, magnitude \\ :hundreds, parsed \\ "")

  defp parse([], _magnitude, parsed) do
    {:ok, String.replace(parsed, ~r/\szero.*/, "")}
  end

  defp parse([digits | number], :hundreds, "") do
    {:ok, last} = in_english(digits)

    parse(number, :thousands, last)
  end

  defp parse([thousands | number], :thousands, hundreds) do
    {:ok, thousands} = in_english(thousands)
    parse(number, :millions, thousands <> " thousand " <> hundreds)
  end

  defp parse([millions | number], :millions, hundreds) do
    {:ok, millions} = in_english(millions)
    parse(number, :billions, millions <> " million " <> hundreds)
  end

  defp parse([billions | number], :billions, hundreds) do
    {:ok, billions} = in_english(billions)
    parse(number, :trillions, billions <> " billion " <> hundreds)
  end

  # defp say(parsed_number) do
  #   System.cmd("espeak-ng", [parsed_number])
  # end
end
