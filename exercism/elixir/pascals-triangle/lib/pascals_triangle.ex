defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(height), do: do_rows(1, height, [[1]])

  defp do_rows(n, n, acc), do: acc |> Enum.reverse()

  defp do_rows(height, max, [last_row | _] = acc) do
    this =
      last_row
      |> do_pairs([])
      |> Enum.map(fn
        [x, y] -> x + y
        [x] -> x
      end)

    do_rows(height + 1, max, [this | acc])
  end

  # do_pairs([1], []) -> [[1], [1]]
  # do_pairs([1, 1], []) -> [[1], [1, 1], [1]]
  # do_pairs([1, 2, 1], []) -> [[1], [2, 1], [1, 2], [1]]
  # do_pairs([1, 3, 3, 1], []) -> [[1], [3, 1], [3, 3], [1, 3], [1]]
  # do_pairs([1, 4, 6, 4, 1], []) -> [[1], [4, 1], [6, 4], [4, 6], [1, 4], [1]]

  defp do_pairs([h | _] = row, []), do: do_pairs(row, [[h]])
  defp do_pairs([h | []], acc), do: [[h] | acc]
  defp do_pairs([f, s | t], acc), do: do_pairs([s | t], [[f, s] | acc])
end
