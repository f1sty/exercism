defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data) do
    %{data: data, left: nil, right: nil}
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(root, data) do
    insert(root, data, root, [])
  end

  defp insert(%{left: nil, data: data}, new_data, tree, path) when new_data <= data do
    left = new(new_data)
    path = Enum.reverse([:left | path])

    put_in(tree, path, left)
  end

  defp insert(%{right: nil, data: data}, new_data, tree, path) when new_data > data do
    right = new(new_data)
    path = Enum.reverse([:right | path])

    put_in(tree, path, right)
  end

  defp insert(node, data, tree, path) do
    cond do
      data > node.data -> insert(node.right, data, tree, [:right | path])
      data <= node.data -> insert(node.left, data, tree, [:left | path])
    end
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(tree) do
    in_order(tree, [])
  end

  defp in_order(%{right: nil, left: nil, data: data}, acc) do
    Enum.sort([data | acc])
  end

  defp in_order(%{right: nil, left: left, data: data}, acc) do
    in_order(left, [data | acc])
  end

  defp in_order(%{right: right, left: nil, data: data}, acc) do
    in_order(right, [data | acc])
  end

  defp in_order(%{left: left, right: right, data: data}, acc) do
    right
    |> in_order([data | acc])
    |> then(&in_order(left, &1))
  end
end
