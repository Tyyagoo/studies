defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(:ones, dice), do: filter_sum(dice, 1)
  def score(:twos, dice), do: filter_sum(dice, 2)
  def score(:threes, dice), do: filter_sum(dice, 3)
  def score(:fours, dice), do: filter_sum(dice, 4)
  def score(:fives, dice), do: filter_sum(dice, 5)
  def score(:sixes, dice), do: filter_sum(dice, 6)

  def score(:full_house, dice) do
    case Enum.sort(dice) do
      [x, x, x, y, y] when x != y -> Enum.sum(dice)
      [y, y, x, x, x] when x != y -> Enum.sum(dice)
      _ -> 0
    end
  end

  def score(:four_of_a_kind, dice) do
    case Enum.sort(dice) do
      [y, y, y, y, _] -> y * 4
      [_, x, x, x, x] -> x * 4
      _ -> 0
    end
  end

  def score(:little_straight, dice) do
    case Enum.sort(dice) do
      [1, 2, 3, 4, 5] -> 30
      _ -> 0
    end
  end

  def score(:big_straight, dice) do
    case Enum.sort(dice) do
      [2, 3, 4, 5, 6] -> 30
      _ -> 0
    end
  end

  def score(:choice, dice), do: Enum.sum(dice)

  def score(:yacht, [x, x, x, x, x]), do: 50
  def score(:yacht, _), do: 0

  defp filter_sum(enum, elem), do: Enum.filter(enum, &(&1 == elem)) |> Enum.sum()
end
