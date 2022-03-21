defmodule CollatzConjecture do
  defguardp is_positive(n) when is_integer(n) and n > 0
  defguardp is_even(n) when is_positive(n) and rem(n, 2) == 0
  defguardp is_odd(n) when is_positive(n) and rem(n, 2) != 0

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input), do: step(input, 0)

  defp step(1, s), do: s
  defp step(n, s) when is_odd(n), do: step(n * 3 + 1, s + 1)
  defp step(n, s) when is_even(n), do: step(div(n, 2), s + 1)
end
