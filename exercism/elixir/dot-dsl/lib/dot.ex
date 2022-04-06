defmodule Dot do
  @spec graph(Macro.t()) :: Macro.t()
  defmacro graph(do: ast) do
    graph =
      case ast do
        {:__block__, _, lines} -> build_graph(lines)
        line -> build_graph([line])
      end

    Macro.escape(graph)
  end

  defp build_graph(lines) do
    lines
    |> Enum.reduce(Graph.new(), fn line, acc ->
      case parse(line) do
        {:edges, {from, to, attrs}} -> Graph.add_edge(acc, from, to, attrs)
        {:nodes, {id, attrs}} -> Graph.add_node(acc, id, attrs)
        {:graph, attrs} -> Graph.put_attrs(acc, attrs)
      end
    end)
  end

  defp parse({:graph, _, [attrs]}) when is_list(attrs) do
    {:graph, attrs}
  end

  defp parse({:--, _, [node_a, node_b]}) do
    {:nodes, {id_a, _}} = parse(node_a)
    {:nodes, {id_b, attrs}} = parse(node_b)
    {:edges, {id_a, id_b, attrs}}
  end

  defp parse({id, _, nil}) do
    {:nodes, {id, []}}
  end

  defp parse({id, _, [attrs]}) when is_list(attrs) do
    {:nodes, {id, attrs}}
  end

  defp parse(_), do: raise(ArgumentError)
end
