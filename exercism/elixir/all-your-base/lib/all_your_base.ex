defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(_, _, output_base) when output_base < 2 do
    {:error, "output base must be >= 2"}
  end

  def convert(_, input_base, _) when input_base < 2 do
    {:error, "input base must be >= 2"}
  end

  def convert(digits, ib, ob) do
    case do_rebase(digits, ib, ob, length(digits) - 1, []) do
      {:error, reason} -> {:error, reason}
      [] -> {:ok, [0]}
      res -> {:ok, res}
    end
  end

  defp do_rebase([], _, ob, _, acc) do
    acc |> Enum.reduce(0, &+/2) |> do_reduce_to(ob, [])
  end

  defp do_rebase([h | _], ib, _, _, _) when h >= ib or h < 0 do
    {:error, "all digits must be >= 0 and < input base"}
  end

  defp do_rebase([h | t], ib, ob, ind, acc) do
    do_rebase(t, ib, ob, ind - 1, [h * Integer.pow(ib, ind) | acc])
  end

  defp do_reduce_to(0, _, acc), do: acc

  defp do_reduce_to(decimal, base, acc) do
    div(decimal, base) |> do_reduce_to(base, [rem(decimal, base) | acc])
  end
end
