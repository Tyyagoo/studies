defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @type school :: map()

  @doc """
  Create a new, empty school.
  """
  @spec new() :: school()
  def new(), do: %{}

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(school(), String.t(), integer) :: {:ok | :error, school()}
  def add(school, name, grade) do
    if contains?(school, name) do
      {:error, school}
    else
      {:ok, Map.update(school, grade, [name], &Enum.sort([name | &1]))}
    end
  end

  @doc """
  Return the names of the students in a particular grade, sorted alphabetically.
  """
  @spec grade(school(), integer) :: [String.t()]
  def grade(school, grade), do: Map.get(school, grade, [])

  @doc """
  Return the names of all the students in the school sorted by grade and name.
  """
  @spec roster(school()) :: [String.t()]
  def roster(school) do
    school
    |> Map.to_list()
    |> Enum.sort_by(fn {grade, _} -> grade end)
    |> Enum.flat_map(fn {_, students} -> students end)
  end

  defp contains?(school, student), do: student in roster(school)
end
