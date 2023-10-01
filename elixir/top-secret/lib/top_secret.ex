defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part({op, meta, [{:when, _meta, args} | _rest]}, acc) do
    decode_secret_message_part({op, meta, args}, acc)
  end

  def decode_secret_message_part({op, _meta, [{fun_name, _, args} | _rest]} = ast, acc)
      when op in ~w[def defp]a do
    arity = length(args)
    string = fun_name |> to_string() |> String.slice(0..(arity - 1))

    {ast, [string | acc]}
  end

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  def decode_secret_message(string) when is_binary(string) do
    string
    |> to_ast()
    |> decode_secret_message("")
  end


  defp decode_secret_message({_op, _meta, args} = ast, acc) do
    {_ast, acc} = decode_secret_message_part(ast, acc) |> IO.inspect(label: :part)
    decode_secret_message(args, acc)
  end

  defp decode_secret_message([{_, _, _} = part | ast], acc) do
    {_ast, acc} = decode_secret_message_part(part, acc) |> IO.inspect(label: :zoom)
    decode_secret_message(ast, acc)
  end

  defp decode_secret_message([part | ast], acc) do
    {_ast, acc} = decode_secret_message_part(part, acc) |> IO.inspect(label: :list)
    decode_secret_message(ast, acc)
  end

  defp decode_secret_message([], acc), do: acc
end
