defmodule Exercises.Chapter2.First do
  @moduledoc """
  Create an expression that solves the following problem: Sarah has bought
  ten slices of bread for ten cents each, three bottles of milk for two dollars
  each, and a cake for fifteen dollars. How many dollars has Sarah spent?
  """

  @bread_price 0.10
  @milk_price 2.0
  @cake_price 50.0

  @doc """
  Calculates how much dollars has Sarah spent.
  
  Example:
    iex>Exercises.Chapter2.First.spent(10, 3, 1)
    57.0
  """
  @spec spent(bread :: integer(), milk :: integer(), cake :: integer) :: float()
  def spent(bread, milk, cake) do
    bread * @bread_price + milk * @milk_price + cake * @cake_price
  end
end
