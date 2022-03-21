defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(_, 0), do: 1

  def largest_product(number_string, size) do
    with true <- size > 0,
         true <- String.length(number_string) >= size,
         true <- Regex.match?(~r/^\d+$/, number_string) do
      do_largest_product(number_string, size)
    else
      _ -> raise ArgumentError
    end
  end

  defp do_largest_product(number_string, size) do
    number_string
    |> String.to_charlist()
    |> Enum.chunk_every(size, 1, :discard)
    |> Enum.map(&Enum.reduce(&1, 1, fn x, acc -> acc * (x - ?0) end))
    |> Enum.max()
  end
end
