defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer()) :: {:ok, pos_integer()} | {:error, String.t()}
  def square(number) when 1 <= number and number <= 64, do: {:ok, Integer.pow(2, number - 1)}
  def square(_), do: {:error, "The requested square must be between 1 and 64 (inclusive)"}

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: {:ok, pos_integer()}
  def total do
    grains =
      1..64
      |> Enum.map(fn x ->
        {:ok, quantity} = square(x)
        quantity
      end)
      |> Enum.reduce(0, &+/2)

    {:ok, grains}
  end
end
