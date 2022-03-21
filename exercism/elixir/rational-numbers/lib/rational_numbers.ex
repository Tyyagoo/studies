import Kernel, except: [abs: 1]

defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({a1, b}, {a2, b}) when a1 === a2 * -1, do: {0, 1}
  def add({a1, b1}, {a2, b2}), do: {a1 * b2 + a2 * b1, b1 * b2} |> reduce()

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract(a, a), do: {0, 1}
  def subtract({a1, b1}, {a2, b2}), do: {a1 * b2 - a2 * b1, b1 * b2} |> reduce()

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({a1, b1}, {a2, b2}), do: {a1 * a2, b1 * b2} |> reduce()

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({_, _}, {0, _}), do: :error
  def divide_by({a1, b1}, {a2, b2}), do: {a1 * b2, a2 * b1} |> reduce()

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({a, b}), do: {Kernel.abs(a), Kernel.abs(b)} |> reduce()

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({a, b}, n) when n >= 0, do: {pow(a, n), pow(b, n)} |> reduce()
  def pow_rational({a, b}, n), do: {pow(b, n * -1), pow(a, n * -1)} |> reduce()

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {a, b}) when a < 0, do: pow(1 / x, a * -1.0) |> pow(1 / b)
  def pow_real(x, {a, b}), do: pow(x, a) |> pow(1 / b)

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({a, b}) when b < 0, do: reduce({a * -1, b * -1})

  def reduce({a, b}) do
    gcd = Integer.gcd(a, b)
    {div(a, gcd), div(b, gcd)}
  end

  defp pow(a, b) when is_integer(a) and is_integer(b), do: Integer.pow(a, b)
  defp pow(a, b) when is_integer(a) and is_float(b), do: Float.pow(a / 1, b)
  defp pow(a, b) when is_float(a) and is_number(b), do: Float.pow(a, b)
end
