defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate(board) do
    sides_idx = for x <- -1..1, y <- -1..1, not(x == 0 and y == 0), do: {x, y}

    board = Enum.map(board, &String.split(&1, "", trim: true))

    board
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.map(fn {row, ridx} ->
      row
      |> Enum.map(fn
        {"*", _} -> "*"
        {" ", cidx} ->
          sides_idx
          |> Enum.reduce(0, fn
            {x, _}, acc when x + ridx < 0 -> acc
            {_, y}, acc when y + cidx < 0 -> acc
            {x, y}, acc -> case board |> Enum.at(x + ridx, []) |> Enum.at(y + cidx) do
              "*" -> acc + 1
              _ -> acc
            end
          end)
          |> case do
            0 -> " "
            n -> Integer.to_string(n)
          end
      end)
    end)
    |> Enum.map(&Enum.join(&1, ""))
  end
end
