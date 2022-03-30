defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    middle_distance = calculate_middle_distance(letter + 1 - ?A)
    width = List.last(middle_distance) + 2

    upperside =
      ?A..letter
      |> Stream.zip(middle_distance)
      |> Stream.map(&format_letter(&1, width))
      |> Enum.to_list()

    lowerside =
      upperside
      |> List.pop_at(-1)
      |> (fn {_popped, list} -> list end).()
      |> Enum.reverse()

    Enum.reduce(upperside ++ lowerside, "", &"#{&2}#{&1}\n")
  end

  defp calculate_middle_distance(number_of_letters) do
    Stream.iterate(0, fn
      0 -> 1
      n -> n + 2
    end)
    |> Enum.take(number_of_letters)
  end

  defp format_letter({?A, 0}, width) do
    padding = String.duplicate(" ", div(width - 1, 2))
    "#{padding}A#{padding}"
  end

  defp format_letter({letter, distance}, width) do
    padding = String.duplicate(" ", div(width - distance - 2, 2))
    middle = String.duplicate(" ", distance)
    "#{padding}#{<<letter>>}#{middle}#{<<letter>>}#{padding}"
  end
end
