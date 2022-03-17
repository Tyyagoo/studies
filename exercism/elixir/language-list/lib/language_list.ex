defmodule LanguageList do
  def new(), do: []

  def add(list, language), do: [language | list]

  def remove([_ | tail]), do: tail

  def first([head | _]), do: head

  def count(list), do: do_count(list, 0)

  def exciting_list?(list), do: do_find(list)

  defp do_count([], acc), do: acc
  defp do_count([_ | tail], acc), do: do_count(tail, acc + 1)

  defp do_find([]), do: false
  defp do_find([head]) when head == "Elixir", do: true
  defp do_find([_ | tail]), do: do_find(tail)
end
