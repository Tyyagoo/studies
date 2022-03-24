defmodule Exercises.Chapter3.Third do
  @moduledoc """
  Create a function that calculates income tax following these rules: a salary
  equal or below $2,000 pays no tax; below or equal to $3,000 pays 5%; below
  or equal to $6,000 pays 10%; everything higher than $6,000 pays 15%.
  """

  @doc """
  Calculate taxes from salaries.
  
  Example:
    iex> alias Exercises.Chapter3.Third
    Exercises.Chapter3.Third
    iex> Third.tax(1500)
    0.0
    iex> Third.tax(3000)
    150.0
    iex> Third.tax(4000)
    400.0
    iex> Third.tax(10000)
    1500.0
  """
  def tax(salary) do
    cond do
      salary <= 2000 -> 0.0
      salary <= 3000 -> salary * 0.05
      salary <= 6000 -> salary * 0.10
      true -> salary * 0.15
    end
    |> Float.round(2)
  end
end
