defmodule StateOfTicTacToe do

  defguardp is_player(letter) when letter in ~w(X O)

  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    # turns the board into a matrix
    board =
      board
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    stats =
      board
      |> List.flatten()
      |> Enum.frequencies()
      |> Map.merge(%{"O" => 0, "X" => 0, "." => 0}, fn _, v1, _v2 -> v1 end) # ensure all keys exists

    %{"X" => x, "O" => o, "." => dot} = stats

    with true <- fail_with_msg(o <= x, "Wrong turn order: O started"),
      true <- fail_with_msg(x - o <= 1, "Wrong turn order: X went twice"),
      {:win, _} <- check_all(board) do
          {:ok, :win}
      else
        :not_known -> if dot == 0, do: {:ok, :draw}, else: {:ok, :ongoing}
        error -> error
      end
  end

  # if the determinated constraint is false, returns a tuple with {:error, message}
  defp fail_with_msg(true, _message), do: true
  defp fail_with_msg(false, message), do: {:error, message}

  defp check_all(board) do
    [{&check_row/2, 3}, {&check_column/2, 3}, {&check_diagonal/2, 2}]
      |> Enum.map(fn {fun, times} -> for n <- 1..times, do: fun.(board, n) end)
      |> List.flatten()
      |> Enum.reduce(:not_known, fn
        {:win, _} = possible_winner, :not_known -> possible_winner
        {:win, a}, {:win, a} -> {:win, a}
        {:win, _}, {:win, _} -> {:error, "Impossible board: game should have ended after the game was won"}
        _el, state -> state
      end)
  end

  defp check_row([[a, a, a], _, _], 1) when is_player(a), do: {:win, a}
  defp check_row([_, [a, a, a], _], 2) when is_player(a), do: {:win, a}
  defp check_row([_, _, [a, a, a]], 3) when is_player(a), do: {:win, a}
  defp check_row(_, _), do: false

  defp check_column([[a, _, _], [a, _, _], [a, _, _]], 1) when is_player(a), do: {:win, a}
  defp check_column([[_, a, _], [_, a, _], [_, a, _]], 2) when is_player(a), do: {:win, a}
  defp check_column([[_, _, a], [_, _, a], [_, _, a]], 3) when is_player(a), do: {:win, a}
  defp check_column(_, _), do: false

  defp check_diagonal([[a, _, _], [_, a, _], [_, _, a]], 1) when is_player(a), do: {:win, a}
  defp check_diagonal([[_, _, a], [_, a, _], [a, _, _]], 2) when is_player(a), do: {:win, a}
  defp check_diagonal(_, _), do: false
end
