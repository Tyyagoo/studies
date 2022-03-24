defmodule Exercises.Chapter3.Second do
  @moduledoc """
  Create a function that returns Tic-Tac-Toe game winners. You can represent
  the board with a tuple of nine elements, where each group of three
  items is a row. The return of the function should be a tuple. When we
  have a winner, the first element should be the atom :winner, and the second
  should be the player. When we have no winner, the tuple should contain
  one item that is the atom :no_winner.
  """

  @doc """
  Calculates how much points a player has spent on his character.
  
  Example:
    iex> alias Exercises.Chapter3.Second
    Exercises.Chapter3.Second
    iex> Second.winner({:x, :o, :x, :o, :x, :o, :o, :o, :x })
    {:winner, :x}
    iex> Second.winner({:x, :o, :x, :o, :x, :o, :o, :x, :o})
    :no_winner
  """
  def winner({:x, :x, :x, _, _, _, _, _, _}), do: {:winner, :x}
  def winner({_, _, _, :x, :x, :x, _, _, _}), do: {:winner, :x}
  def winner({_, _, _, _, _, _, :x, :x, :x}), do: {:winner, :x}
  def winner({:x, _, _, :x, _, _, :x, _, _}), do: {:winner, :x}
  def winner({_, :x, _, _, :x, _, _, :x, _}), do: {:winner, :x}
  def winner({_, _, :x, _, _, :x, _, _, :x}), do: {:winner, :x}
  def winner({:x, _, _, _, :x, _, _, _, :x}), do: {:winner, :x}
  def winner({_, _, :x, _, :x, _, :x, _, _}), do: {:winner, :x}

  def winner({:y, :y, :y, _, _, _, _, _, _}), do: {:winner, :y}
  def winner({_, _, _, :y, :y, :y, _, _, _}), do: {:winner, :y}
  def winner({_, _, _, _, _, _, :y, :y, :y}), do: {:winner, :y}
  def winner({:y, _, _, :y, _, _, :y, _, _}), do: {:winner, :y}
  def winner({_, :y, _, _, :y, _, _, :y, _}), do: {:winner, :y}
  def winner({_, _, :y, _, _, :y, _, _, :y}), do: {:winner, :y}
  def winner({:y, _, _, _, :y, _, _, _, :y}), do: {:winner, :y}
  def winner({_, _, :y, _, :y, _, :y, _, _}), do: {:winner, :y}

  def winner(_), do: :no_winner
end
