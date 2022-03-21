defmodule Allergies do
  @allergy_map %{
    "eggs" => 1,
    "peanuts" => 2,
    "shellfish" => 4,
    "strawberries" => 8,
    "tomatoes" => 16,
    "chocolate" => 32,
    "pollen" => 64,
    "cats" => 128
  }

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    @allergy_map
    |> Enum.filter(fn {k, _} -> allergic_to?(flags, k) end)
    |> Enum.map(fn {k, _} -> k end)
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item), do: @allergy_map |> Map.get(item, 0) |> Bitwise.&&&(flags) !== 0
end
