defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data), do: %{data: data, left: nil, right: nil}

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(nil, data), do: new(data)

  def insert(node, data) when data > node.data do
    %{node | right: insert(node.right, data)}
  end

  def insert(node, data) do
    %{node | left: insert(node.left, data)}
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(tree), do: do_walk(tree, [])

  defp do_walk(nil, acc), do: acc

  defp do_walk(tree, acc) do
    do_walk(tree.left, [tree.data | do_walk(tree.right, acc)])
  end
end
