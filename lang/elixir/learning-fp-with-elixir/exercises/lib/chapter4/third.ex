defmodule Exercises.Chapter4.Third do
  @moduledoc """
  We’ve created a function that sorts the items of a list in ascending order.
  Now create a Sort.descending/1 function that sorts the elements in descending order.
  """

  @doc """
  Sorts a list in desired order. Defaults to ascending.
  
  Example:
  iex> alias Exercises.Chapter4.Third
  Exercises.Chapter4.Third
  iex> list = [6988, 1887, 7311, 2680, 1045, 1324, 6633, 9248, 2112, 4718]
  [6988, 1887, 7311, 2680, 1045, 1324, 6633, 9248, 2112, 4718]
  iex> Third.sort(list, :ascending)
  [1045, 1324, 1887, 2112, 2680, 4718, 6633, 6988, 7311, 9248]
  iex> Third.sort(list, :descending)
  [9248, 7311, 6988, 6633, 4718, 2680, 2112, 1887, 1324, 1045]
  """
  def sort(list, :ascending), do: sort(list, fn a, b -> a < b end)
  def sort(list, :descending), do: sort(list, fn a, b -> a > b end)

  def sort(list, comparator) do
    len = size(list)
    divide(list, len, comparator)
  end

  defp divide([], _, _), do: []
  defp divide([_] = list, _, _), do: list

  defp divide(list, len, comparator) do
    half = div(len, 2)
    {la, lb} = slice_at(list, half)

    conquer(divide(la, half, comparator), divide(lb, len - half, comparator), comparator, [])
  end

  defp conquer([ha | ta] = la, [hb | tb] = lb, comparator, acc) do
    if comparator.(ha, hb) do
      conquer(ta, lb, comparator, [ha | acc])
    else
      conquer(la, tb, comparator, [hb | acc])
    end
  end

  defp conquer([head | tail], [], cmp, acc), do: conquer(tail, [], cmp, [head | acc])
  defp conquer([], [head | tail], cmp, acc), do: conquer(tail, [], cmp, [head | acc])
  # that's "good" for memory, but terrible for cpu
  # without tail call, it's nice for cpu, but bad for memory
  defp conquer([], [], _, acc), do: acc |> reverse()

  defp size(list), do: do_size(list, 0)
  defp do_size([_ | tail], acc), do: do_size(tail, acc + 1)
  defp do_size([], acc), do: acc

  defp reverse(list), do: do_reverse(list, [])
  defp do_reverse([head | tail], acc), do: do_reverse(tail, [head | acc])
  defp do_reverse([], acc), do: acc

  defp slice_at(list, index), do: do_slice_at(list, index, [])

  defp do_slice_at([head | tail], index, acc) when index > 0 do
    do_slice_at(tail, index - 1, [head | acc])
  end

  defp do_slice_at(remaining_list, _, acc), do: {acc |> reverse(), remaining_list}
end
