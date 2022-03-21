defmodule Garden do
  @default_children [
    :alice,
    :bob,
    :charlie,
    :david,
    :eve,
    :fred,
    :ginny,
    :harriet,
    :ileana,
    :joseph,
    :kincaid,
    :larry
  ]

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @default_children) do
    students = Enum.sort_by(student_names, &Atom.to_string/1)
    map = Enum.into(students, %{}, &{&1, {}})

    info_string
    |> String.split("\n")
    |> Enum.reduce(map, &plants_in_row(&2, &1, students))
  end

  defp plants_in_row(students, <<>>, _), do: students

  defp plants_in_row(students, <<f, s, rest::binary>>, [owner | tail]) do
    pbl = &plant_by_letter/1

    students
    |> Map.update!(owner, fn t ->
      t
      |> Tuple.append(pbl.(f))
      |> Tuple.append(pbl.(s))
    end)
    |> plants_in_row(rest, tail)
  end

  defp plant_by_letter(?G), do: :grass
  defp plant_by_letter(?C), do: :clover
  defp plant_by_letter(?R), do: :radishes
  defp plant_by_letter(?V), do: :violets
end
