defmodule Exercises.Chapter4.Second do
  @moduledoc """
  In the section Transforming Lists, on page 62, we traveled to a fantasy
  world and enchanted some items. Create a new module called GeneralStore
  where you can create a function that filters based on whether the products
  are magical.
  """

  @doc """
  Filter items by it's magic property.
  
  Examples:
  iex> data = [
  ...>  %{title: "Longsword", price: 50, magic: false},
  ...>  %{title: "Healing Potion", price: 60, magic: true},
  ...>  %{title: "Rope", price: 10, magic: false},
  ...>  %{title: "Dragon's Spear", price: 100, magic: true}]
  iex> alias Exercises.Chapter4.Second
  Exercises.Chapter4.Second
  iex> Second.filter_items(data, magic: true)
  [
    %{title: "Healing Potion", price: 60, magic: true},
    %{title: "Dragon's Spear", price: 100, magic: true}
  ]
  iex> Second.filter_items(data, magic: false)
  [
    %{title: "Longsword", price: 50, magic: false},
    %{title: "Rope", price: 10, magic: false}
  ]
  iex> Second.filter_items(data)
  [
    %{title: "Longsword", price: 50, magic: false},
    %{title: "Rope", price: 10, magic: false}
  ]
  """
  def filter_items(items, opts \\ []) do
    magic = opts[:magic] || false
    items |> filter_by_magic(magic, []) |> reverse([])
  end

  defp filter_by_magic([%{magic: magic} = head | tail], magic, acc),
    do: filter_by_magic(tail, magic, [head | acc])

  defp filter_by_magic([_ | tail], magic, acc), do: filter_by_magic(tail, magic, acc)
  defp filter_by_magic([], _, acc), do: acc

  defp reverse([head | tail], acc), do: reverse(tail, [head | acc])
  defp reverse([], acc), do: acc
end
