defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand), do: babylonian(100, radicand, 13)

  defp babylonian(x, _, 0), do: x

  defp babylonian(x, r, steps) do
    ((x + r / x) / 2)
    |> babylonian(r, steps - 1)
  end
end
