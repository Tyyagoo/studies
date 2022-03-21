defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) do
    aliquot_sum = calc(number, number - 1, 0)

    cond do
      :error === aliquot_sum -> {:error, "Classification is only possible for natural numbers."}
      number === aliquot_sum -> {:ok, :perfect}
      number > aliquot_sum -> {:ok, :deficient}
      number < aliquot_sum -> {:ok, :abundant}
    end
  end

  defp calc(number, _, _) when number < 1, do: :error
  defp calc(_, n, acc) when n <= 1, do: acc + n
  defp calc(number, n, acc) when rem(number, n) !== 0, do: calc(number, n - 1, acc)
  defp calc(number, n, acc), do: calc(number, n - 1, acc + n)
end
