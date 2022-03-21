defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    sentence
    |> String.downcase()
    |> String.graphemes()
    |> Enum.filter(&(&1 != " " and &1 != "-"))
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.any?(fn {_, quantity} -> quantity != 1 end)
    |> Kernel.not()
  end
end
