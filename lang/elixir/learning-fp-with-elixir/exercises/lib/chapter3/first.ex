defmodule Exercises.Chapter3.First do
  @moduledoc """
  In RPGs, players have points to spend on their character attributes. Create
  a function that returns the total number of points players have spent on
  their characters. The function will receive a map containing the strength,
  dexterity, and intelligence values. Each point in strength should be multiplied
  by two, and dexterity and intelligence should be multiplied by three.
  """

  @strength 2
  @dexterity 3
  @intelligence 3

  @doc """
  Calculates how much points a player has spent on his character.
  
  Example:
    iex> Exercises.Chapter3.First.points(%{strength: 10, dexterity: 4, intelligence: 7})
    53
  """
  def points(%{strength: str, dexterity: dex, intelligence: int}) do
    str * @strength + dex * @dexterity + int * @intelligence
  end
end
