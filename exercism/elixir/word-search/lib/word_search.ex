defmodule WordSearch do
  defmodule Location do
    defstruct [:from, :to]

    @type t :: %Location{
            from: %{row: integer, column: integer},
            to: %{row: integer, column: integer}
          }
  end

  @doc """
  Find the start and end positions of words in a grid of letters.
  Row and column positions are 1 indexed.
  """
  @spec search(grid :: String.t(), words :: [String.t()]) :: %{String.t() => nil | Location.t()}
  def search(grid, words) do
    grid =
      grid
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    max_x = length(grid) - 1
    max_y = length(Enum.at(grid, 0)) - 1

    initials = Enum.map(words, &String.at(&1, 0)) |> Enum.uniq()

    for x <- 0..max_x, y <- 0..max_y, i = at_grid(grid, x, y), i in initials do
      words
      |> Enum.filter(&(String.at(&1, 0) == i))
      |> Enum.flat_map(&lookup_word(grid, &1, x, y, max_x, max_y))
      |> Enum.filter(& &1)
    end
    |> List.flatten()
    |> Enum.into(Enum.into(words, %{}, &{&1, nil}))
  end

  def at_grid(grid, x, y), do: Enum.at(grid, x, []) |> Enum.at(y)

  defp lookup_word(grid, word, x, y, max_x, max_y) do
    len = String.length(word) - 1

    for dx <- -1..1,
        dy <- -1..1,
        xs = generate_axis(x, len, dx),
        ys = generate_axis(y, len, dy),
        not (dx == 0 and dy == 0),
        Enum.all?(xs, &in_bounds?(&1, max_x)),
        Enum.all?(ys, &in_bounds?(&1, max_y)) do
      Enum.zip(xs, ys)
      |> then(fn pos ->
        case Enum.map_join(pos, fn {x, y} -> at_grid(grid, x, y) end) do
          ^word ->
            {from_x, from_y} = List.first(pos)
            {to_x, to_y} = List.last(pos)

            {word,
             %Location{
               from: %{row: from_x + 1, column: from_y + 1},
               to: %{row: to_x + 1, column: to_y + 1}
             }}

          _ ->
            nil
        end
      end)
    end
  end

  defp generate_axis(z, len, 0), do: Stream.cycle([z]) |> Enum.take(len + 1)
  defp generate_axis(z, len, -1), do: z..(z - len)//-1 |> Enum.to_list()
  defp generate_axis(z, len, 1), do: z..(z + len) |> Enum.to_list()

  defp in_bounds?(z, max_z) when z >= 0, do: z <= max_z
  defp in_bounds?(_, _), do: false
end
