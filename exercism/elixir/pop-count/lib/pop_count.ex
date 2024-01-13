defmodule PopCount do
  import Bitwise
  @doc """
  Given the number, count the number of eggs.
  """
  @spec egg_count(number :: integer()) :: non_neg_integer()
  def egg_count(number), do: do_egg_count(number, 0)

  defp do_egg_count(0, eggs), do: eggs
  defp do_egg_count(n, eggs), do: do_egg_count(n >>> 1, eggs + (n &&& 1))
end
