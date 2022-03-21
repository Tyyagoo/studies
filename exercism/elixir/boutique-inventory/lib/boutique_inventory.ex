defmodule BoutiqueInventory do
  def sort_by_price(inventory), do: inventory |> Enum.sort_by(& &1.price)

  def with_missing_price(inventory), do: inventory |> Enum.filter(&(&1.price === nil))

  def increase_quantity(item, count) do
    quantity_by_size =
      item.quantity_by_size
      |> Enum.map(fn {key, value} -> {key, value + count} end)
      |> Enum.into(%{})

    %{name: item.name, price: item.price, quantity_by_size: quantity_by_size}
  end

  def total_quantity(item),
    do: item.quantity_by_size |> Enum.reduce(0, fn {_, value}, acc -> value + acc end)
end
