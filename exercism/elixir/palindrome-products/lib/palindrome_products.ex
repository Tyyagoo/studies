defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max, min \\ 1)
  def generate(max, min) when min > max, do: raise(ArgumentError)

  def generate(max, min) do
    for x <- min..max, y <- x..max, palindrome?(x * y) do
      {x * y, [x, y]}
    end
    |> Enum.group_by(fn {key, _} -> key end, fn {_, value} -> value end)
  end

  defp palindrome?(number) do
    number
    |> Integer.digits()
    |> Enum.reverse()
    |> Integer.undigits()
    |> Kernel.==(number)
  end
end
