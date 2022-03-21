defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number), do: do_factors(number, 2, [])

  defp do_factors(1, _, acc), do: acc |> Enum.reverse()

  defp do_factors(number, factor, acc) when rem(number, factor) == 0,
    do: do_factors(div(number, factor), factor, [factor | acc])

  defp do_factors(number, factor, acc), do: do_factors(number, factor + 1, acc)
end
