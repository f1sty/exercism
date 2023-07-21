defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part({operation, _, [{:when, _, body} | _]} = ast, acc)
      when operation in ~w[def defp]a do
    {name, _meta, args} = hd(body)
    decoded = decode(name, args)

    {ast, [decoded | acc]}
  end

  def decode_secret_message_part({operation, _, [{name, _, args} | _]} = ast, acc)
      when operation in ~w[def defp]a do
    decoded = decode(name, args)

    {ast, [decoded | acc]}
  end

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  def decode_secret_message(string) when is_binary(string) do
    string
    |> to_ast()
    |> decode_secret_message([], [])
  end

  defp decode_secret_message({_, _, [next | rest]} = ast_node, nodes, acc) do
    {^ast_node, acc} = decode_secret_message_part(ast_node, acc)
    decode_secret_message(next, List.wrap(rest) ++ nodes, acc)
  end

  defp decode_secret_message([do: block], nodes, acc) do
    decode_secret_message(block, nodes, acc)
  end

  defp decode_secret_message(_other, [ast_node | nodes], acc) do
    decode_secret_message(ast_node, nodes, acc)
  end

  defp decode_secret_message(_, [], acc) do
    acc
    |> Enum.reverse()
    |> Enum.join()
  end

  defp decode(_name, args) when is_nil(args) or args == [], do: ""

  defp decode(name, args) do
    arity = length(args)

    name
    |> Atom.to_string()
    |> String.slice(0..(arity - 1))
  end
end
