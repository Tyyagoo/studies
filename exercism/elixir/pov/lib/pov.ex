defmodule Pov do
  @typedoc """
  A tree, which is made of a node with several branches
  """
  @type tree :: {any, [tree]}

  @nonexistent_target {:error, :nonexistent_target}

  @doc """
  Reparent a tree on a selected node.
  """
  @spec from_pov(tree :: tree, node :: any) :: {:ok, tree} | {:error, atom}
  def from_pov(tree, node) do
    case dfs(tree, node, []) do
      {:ok, [found]} -> {:ok, found}
      {:ok, [root | children]} -> {:ok, reroot(root, children) |> hd}
      :error -> @nonexistent_target
    end
  end

  @doc """
  Finds a path between two nodes
  """
  @spec path_between(tree :: tree, from :: any, to :: any) :: {:ok, [any]} | {:error, atom}
  def path_between(tree, from, to) do
    with {:ok, rerooted} <- from_pov(tree, from),
         {:ok, path} <- dfs(rerooted, to, []) do
      path
      |> Enum.reverse()
      |> Enum.map(fn {value, _} -> value end)
      |> then(&{:ok, &1})
    else
      @nonexistent_target -> {:error, :nonexistent_source}
      :error -> {:error, :nonexistent_destination}
    end
  end

  defp dfs({found, _} = node, found, path), do: {:ok, [node | path]}

  defp dfs({_, children} = node, target, path) do
    children
    |> Enum.reduce_while(:error, fn child, _ ->
      case dfs(child, target, [node | path]) do
        {:ok, _} = result -> {:halt, result}
        _ -> {:cont, :error}
      end
    end)
  end

  defp reroot(leaf, []), do: [leaf]

  defp reroot({rv, rc}, [{pv, pc} | path]) do
    root_removed = Enum.reject(pc, &(elem(&1, 0) == rv))
    children = reroot({pv, root_removed}, path)
    [{rv, rc ++ children}]
  end
end