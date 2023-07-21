defmodule SecretHandshake do
  require Bitwise

  @actions [
    "wink",
    "double blink",
    "close your eyes",
    "jump"
  ]

  @actions_map Enum.into(0..4, %{}, fn shift ->
                 {Bitwise.bsl(0b1, shift), Enum.at(@actions, shift, :reverse)}
               end)

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    code
    |> Integer.digits(2)
    |> to_actions()
  end

  @doc """
  Solution using binary operators. According to Benchee results this one is 1.03-4x slower.
  """
  @spec commands_binary(code :: integer) :: list(String.t())
  def commands_binary(code) do
    Enum.map(0..4, fn shift ->
      0b1
      |> Bitwise.bsl(shift)
      |> Bitwise.band(code)
      |> then(fn idx -> Map.get(@actions_map, idx) end)
    end)
    |> Enum.reject(&is_nil/1)
    |> then(fn actions ->
      case List.last(actions) == :reverse do
        true ->
          [_reverse_flag | actions] = Enum.reverse(actions)
          actions

        false ->
          actions
      end
    end)
  end

  defp to_actions(flags) when length(flags) <= 5 do
    actions_qty = length(flags)
    actions_list = Enum.take(@actions, actions_qty)

    {reversed?, flags} = (actions_qty == 5 && {true, tl(flags)}) || {false, flags}

    actions =
      flags
      |> Enum.reverse()
      |> Enum.zip(actions_list)
      |> Enum.filter(fn {include?, _action} -> include? == 1 end)
      |> Enum.map(&elem(&1, 1))

    (reversed? && Enum.reverse(actions)) || actions
  end

  defp to_actions(_), do: []
end
