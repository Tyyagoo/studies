defmodule Queens do
  defguardp is_valid_axis(n) when 0 <= n and n <= 7

  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(opts \\ []) do
    opts
    |> Enum.map(fn
      {:white, queen} -> {:white, valid_position!(queen)}
      {:black, queen} -> {:black, valid_position!(queen)}
      _ -> raise ArgumentError
    end)
    |> Enum.reduce(%Queens{}, fn
      {:white, queen}, acc -> %Queens{acc | white: queen}
      {:black, queen}, acc -> %Queens{acc | black: queen}
    end)
    |> same_place!()
  end

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    "_"
    |> List.duplicate(8)
    |> List.duplicate(8)
    |> replace_queen("W", queens.white)
    |> replace_queen("B", queens.black)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.join("\n")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{white: {x, _}, black: {x, _}}), do: true
  def can_attack?(%Queens{white: {_, y}, black: {_, y}}), do: true
  def can_attack?(%Queens{white: {x1, y1}, black: {x2, y2}}), do: abs(x1 - x2) == abs(y1 - y2)
  def can_attack?(_), do: false

  defp valid_position!({x, y} = queen) when is_valid_axis(x) and is_valid_axis(y), do: queen
  defp valid_position!(_), do: raise(ArgumentError)

  defp same_place!(%Queens{white: {x, y}, black: {x, y}}), do: raise(ArgumentError)
  defp same_place!(queens), do: queens

  defp replace_queen(table, _, nil), do: table

  defp replace_queen(table, queen, {x, y}) do
    row = table |> Enum.at(x) |> List.replace_at(y, queen)
    table |> List.replace_at(x, row)
  end
end
