defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  defguardp is_any_side_negative(a, b, c) when a <= 0 or b <= 0 or c <= 0
  defguardp is_valid(a, b, c) when a + b > c and a + c > b and b + c > a
  defguardp is_equilateral(a, b, c) when a === b and a === c
  defguardp is_isosceles(a, b, c) when a === b or a === c or b === c
  defguardp is_scalene(a, b, c) when a !== b and a !== c and b !== c

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) when is_any_side_negative(a, b, c),
    do: {:error, "all side lengths must be positive"}

  def kind(a, b, c) when not is_valid(a, b, c),
    do: {:error, "side lengths violate triangle inequality"}

  def kind(a, b, c) when is_equilateral(a, b, c), do: {:ok, :equilateral}
  def kind(a, b, c) when is_isosceles(a, b, c), do: {:ok, :isosceles}
  def kind(a, b, c) when is_scalene(a, b, c), do: {:ok, :scalene}
end
