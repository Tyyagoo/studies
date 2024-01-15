defmodule Alphametics do
  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

    iex> Alphametics.solve("I + BB == ILL")
    %{?I => 1, ?B => 9, ?L => 0}

    iex> Alphametics.solve("A == B")
    nil
  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    letters =
      Regex.scan(~r/\w/, puzzle)
      |> Enum.uniq
      |> Enum.map(fn [s] -> String.to_charlist(s) end)
      |> List.flatten

    terms =
      Regex.scan(~r/\w+/, puzzle)
      |> Enum.map(fn [s] -> String.to_charlist(s) end)

    with {:ok, solution} <- do_solve(%{}, letters, terms), do: solution
  end

  defp do_solve(acc, [], terms), do: solved?(acc, terms)

  defp do_solve(acc, [lt | letters], terms) do
    Enum.to_list(0..9) -- Map.values(acc)
    |> Enum.reduce_while(nil, fn x, _ ->
      case do_solve(Map.put_new(acc, lt, x), letters, terms) do
        {:ok, _} = ok -> {:halt, ok}
        _ -> {:cont, nil}
      end
    end)
  end

  defp solved?(acc, terms) do
    [x | xs] =
      terms
      |> Enum.map(&to_number(acc, &1))
      |> Enum.reverse

    if Enum.sum(xs) == x, do: {:ok, acc}, else: :error
  end

  defp to_number(map, digits) do
    Enum.map(digits, fn x -> Map.get(map, x) |> to_string end)
    |> Enum.join("")
    |> case do
      <<?0::utf8, _rest::binary>> -> -1
      str -> String.to_integer(str)
    end
  end
end
