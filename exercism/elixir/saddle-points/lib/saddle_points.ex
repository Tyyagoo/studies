defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&split_to_integer/1)
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
  def saddle_points(""), do: []

  def saddle_points(str) do
    rs = rows(str)
    cs = columns(str)
    lrs = length(rs) - 1
    lcs = length(cs) - 1

    for(r <- 0..lrs, c <- 0..lcs, do: find_saddle(rs, cs, r, c))
    |> Enum.filter(&(&1 != nil))
  end

  defp find_saddle(rows, cols, r, c) do
    row = Enum.at(rows, r)
    col = Enum.at(cols, c)
    val = Enum.at(row, c)

    if Enum.all?(row, &Kernel.>=(val, &1)) and Enum.all?(col, &Kernel.<=(val, &1)) do
      {r + 1, c + 1}
    end
  end

  defp split_to_integer(row) do
    row
    |> String.split()
    |> Enum.map(fn s ->
      {int, _rem} = Integer.parse(s)
      int
    end)
  end
end
