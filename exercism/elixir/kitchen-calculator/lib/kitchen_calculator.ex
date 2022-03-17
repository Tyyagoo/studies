defmodule KitchenCalculator do
  @typep unit :: :milliliter | :cup | :fluid_ounce | :teaspoon | :tablespoon
  @type measure :: {unit(), number()}

  @spec get_volume(measure()) :: number()
  def get_volume({_, volume}), do: volume

  @spec to_milliliter(measure()) :: {:milliliter, number}
  def to_milliliter({unit, volume}), do: {:milliliter, volume * rate(unit)}

  @spec from_milliliter(measure(), unit()) :: measure()
  def from_milliliter({_, volume}, unit), do: {unit, volume / rate(unit)}

  @spec convert(measure(), unit()) :: measure()
  def convert(actual, target), do: actual |> to_milliliter() |> from_milliliter(target)

  defp rate(:milliliter), do: 1
  defp rate(:cup), do: 240
  defp rate(:fluid_ounce), do: 30
  defp rate(:teaspoon), do: 5
  defp rate(:tablespoon), do: 15
end
