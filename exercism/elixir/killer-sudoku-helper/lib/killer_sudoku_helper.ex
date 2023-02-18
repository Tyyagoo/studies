defmodule KillerSudokuHelper do
  @numbers 1..9

  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{exclude: exclude, size: size, sum: sum}) do
    @numbers
    |> Enum.reject(fn x -> x > sum || x in exclude end)
    |> do_combinations(size)
    |> Enum.filter(fn ls -> Enum.sum(ls) == sum end)
  end

  # https://rosettacode.org/wiki/Combinations#Erlang
  defp do_combinations(_, 0), do: [[]]
  defp do_combinations([], _), do: []

  defp do_combinations([hd | tl], size) do
    for(x <- do_combinations(tl, size - 1), do: [hd | x]) ++ do_combinations(tl, size)
  end
end
