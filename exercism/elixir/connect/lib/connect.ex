defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board) do
    board = Enum.map(board, &String.graphemes/1)
    x = length(board)
    y = length(hd(board))

    white =
      hd(board)
      |> map_piece_index("O")
      |> Enum.map(&{0, &1})
      |> then(&do_result(board, "O", &1, {x - 1, :any}, {x, y}, MapSet.new()))

    black =
      board
      |> Enum.map(&hd/1)
      |> map_piece_index("X")
      |> Enum.map(&{&1, 0})
      |> then(&do_result(board, "X", &1, {:any, y - 1}, {x, y}, MapSet.new()))

    case {white, black} do
      {true, false} -> :white
      {false, true} -> :black
      {false, false} -> :none
      {true, true} -> :wtf
    end
  end

  defp do_result(_, _, [], _, _, _), do: false
  defp do_result(_, _, [{_, j} | _], {:any, j}, _, _), do: true
  defp do_result(_, _, [{i, _} | _], {i, :any}, _, _), do: true

  defp do_result(board, piece, [{i, j} | candidates], target, limits, visited) do
    adj =
      adjacency(i, j)
      |> Enum.filter(&(inside?(&1, limits) and not MapSet.member?(visited, &1)))
      |> Enum.filter(fn {i, j} ->
        board
        |> Enum.at(i)
        |> Enum.at(j)
        |> Kernel.==(piece)
      end)

    visited = MapSet.put(visited, {i, j})

    if do_result(board, piece, adj, target, limits, visited) do
      true
    else
      do_result(board, piece, candidates, target, limits, visited)
    end
  end

  defp adjacency(i, j),
    do: [{i + 1, j}, {i + 1, j - 1}, {i, j - 1}, {i, j + 1}, {i - 1, j}, {i - 1, j + 1}]

  defp inside?({i, j}, {x, y}), do: i >= 0 and i < x and j >= 0 and j < y

  defp map_piece_index(list, piece) do
    Enum.with_index(list)
    |> Enum.map(fn
      {^piece, idx} -> idx
      _ -> nil
    end)
    |> Enum.filter(& &1)
  end
end
