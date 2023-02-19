defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(fn r -> String.split(r) |> Enum.map(&String.to_integer/1) end)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    str
    |> rows()
    |> Enum.zip_with(& &1)
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    for {row, x} <- Enum.with_index(rows(str), 1),
        {col, y} <- Enum.with_index(columns(str), 1),
        Enum.max(row) == Enum.min(col),
        do: {x, y}
  end
end
