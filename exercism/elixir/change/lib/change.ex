defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) do
    coins
    |> Enum.reverse()
    |> generate_all(target, [])
    |> case do
      [] -> {:error, "cannot change"}
      possibilities -> {:ok, possibilities |> Enum.min_by(&length/1)}
    end
  end

  defp generate_all([_ | tl] = coins, target, possibilities) do
    possibilities = [do_generate(coins, target, []) | possibilities]
    generate_all(tl, target, possibilities)
  end

  defp generate_all([], _, possibilities) do
    possibilities
    |> Enum.filter(&is_list/1)
  end

  defp do_generate([hd | tl] = coins, target, acc) when target >= hd do
    case do_generate(coins, target - hd, [hd | acc]) do
      # if `[hd | tl]` gives an "wrong" path, try for `tl`
      :error -> do_generate(tl, target, acc)
      result -> result
    end
  end

  defp do_generate([_ | tl], target, acc), do: do_generate(tl, target, acc)
  defp do_generate(_, 0, acc), do: acc
  defp do_generate([], _, _), do: :error
end
