defmodule Exercises.Chapter4.First do
  @moduledoc """
  Write two recursive functions: one that finds the biggest element of a list
  and another that finds the smallest.
  """

  @doc """
  Find the biggest value in the list.
  
  Example:
    iex> [4, 2, 16, 9, 10] |> Exercises.Chapter4.First.max()
    16
  """
  def max(list) do
    greater = fn
      :neg_inf, b -> b
      a, :neg_inf -> a
      a, b -> if a > b, do: a, else: b
    end

    list
    |> find(greater, :neg_inf)
  end

  @doc """
  Find the lowest value in the list.
  
  Example:
    iex> [4, 2, 16, 9, 10] |> Exercises.Chapter4.First.min()
    2
  """
  def min(list) do
    lesser = fn
      :pos_inf, b -> b
      a, :pos_inf -> a
      a, b -> if a < b, do: a, else: b
    end

    list
    |> find(lesser, :pos_inf)
  end

  defp find([head | tail], comparator, current) do
    find(tail, comparator, comparator.(current, head))
  end

  defp find([], _, current), do: current
end
