defmodule ComplexNumbers do
  import Kernel, except: [abs: 1, div: 2]

  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {float, float}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: float
  def real({a, _}), do: a

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: float
  def imaginary({_, b}), do: b

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | float, b :: complex | float) :: complex
  def mul({a, b}, {c, d}), do: {a * c - b * d, b * c + a * d}
  def mul(a, b), do: mul(to_complex(a), to_complex(b))

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | float, b :: complex | float) :: complex
  def add({a, b}, {c, d}), do: {a + c, b + d}
  def add(a, b), do: add(to_complex(a), to_complex(b))

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | float, b :: complex | float) :: complex
  def sub({a, b}, {c, d}), do: {a - c, b - d}
  def sub(a, b), do: sub(to_complex(a), to_complex(b))

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | float, b :: complex | float) :: complex
  def div({a, b}, {c, d}) do
    x = pow2(c) + pow2(d)
    {(a * c + b * d) / x, (b * c - a * d) / x}
  end

  def div(a, b), do: div(to_complex(a), to_complex(b))

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: float
  def abs({a, b}), do: Kernel.abs(sqrt(pow2(a) + pow2(b)))

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({a, b}), do: {a, b * -1}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp({a, b}), do: {:math.exp(a) * :math.cos(b), :math.sin(b)}

  defp to_complex(x) when is_number(x), do: {x, 0}
  defp to_complex(x) when is_tuple(x), do: x

  defp pow2(x) when is_float(x), do: Float.pow(x, 2)
  defp pow2(x) when is_number(x), do: Integer.pow(x, 2)

  defp sqrt(x), do: :math.sqrt(x)
end
