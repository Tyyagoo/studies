defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """
  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer
  def maximum_value(items, maximum_weight) do
    1..length(items)
    |> Enum.flat_map(&do_combinations(items, &1))
    |> Enum.map(&reduce_weight_and_value/1)
    |> Enum.reject(&(&1.weight > maximum_weight))
    |> Enum.max_by(& &1.value, fn -> %{value: 0} end)
    |> Map.fetch!(:value)
  end

  defp do_combinations(_, 0), do: [[]]
  defp do_combinations([], _), do: []

  defp do_combinations([hd | tl], size) do
    for(x <- do_combinations(tl, size - 1), do: [hd | x]) ++ do_combinations(tl, size)
  end

  defp reduce_weight_and_value(items) do
    Enum.reduce(items, %{value: 0, weight: 0}, &Map.merge(&1, &2, fn _k, v1, v2 -> v1 + v2 end))
  end
end
