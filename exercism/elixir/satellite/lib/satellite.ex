defmodule Satellite do
  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style
  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}

  def build_tree([], []), do: {:ok, {}}

  def build_tree([root | xs] = preorder, inorder) do
    with :ok <- unique(preorder),
         :ok <- unique(inorder),
         :ok <- same_length(preorder, inorder),
         {_, _, _} = tree <- do_build_tree(root, xs, inorder, {}) do
      {:ok, tree}
    end
  end

  defp do_build_tree(root, [], [root | _], acc), do: {acc, root, {}}

  defp do_build_tree(root, [new_root | new_preorder], [root | new_inorder], acc),
    do: {acc, root, do_build_tree(new_root, new_preorder, new_inorder, {})}

  defp do_build_tree(root, [_ | xs], [y | ys], acc),
    do: do_build_tree(root, xs, ys, {acc, y, {}})

  defp do_build_tree(_, _, _, _), do: {:error, "traversals must have the same elements"}

  defp unique(xs) do
    cond do
      length(xs) == length(Enum.uniq(xs)) -> :ok
      true -> {:error, "traversals must contain unique items"}
    end
  end

  defp same_length(xs, ys) do
    cond do
      length(xs) == length(ys) -> :ok
      true -> {:error, "traversals must have the same length"}
    end
  end
end