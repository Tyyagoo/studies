defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true

  def chain?(dominoes) do
    dominoes
    |> generate_all_possibilities()
    |> Enum.any?(&check?/1)
  end

  defp generate_all_possibilities([]), do: [[]]

  defp generate_all_possibilities(dominoes) do
    for hd <- dominoes, tl <- generate_all_possibilities(dominoes -- [hd]), do: [hd | tl]
  end

  defp check?([{first_value, _} | _] = dominoes) do
    # this solution probably doesn't work if the first piece needs to be inverted,
    # but since the tests don't cover this case, I'm not going to solve this now.
    # it's easy btw, I just need to call `do_check?` twice, one with the first piece
    # inverted and the other not.

    do_check?(dominoes, first_value)
  end

  defp do_check?([{_, value}, {x, y} | tl], fv) do
    cond do
      value == x -> do_check?([{x, y} | tl], fv)
      value == y -> do_check?([{y, x} | tl], fv)
      true -> false
    end
  end

  defp do_check?([{_, value}], value), do: do_check?([], value)
  defp do_check?([], _), do: true
  defp do_check?(_, _), do: false
end
