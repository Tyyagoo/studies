defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []

  def matrix(dimension) do
    Matrix.new(dimension, dimension)
    |> generate(0, 0, 1, :right, dimension * dimension)
    |> Matrix.to_list()
  end

  defp generate(matrix, _, _, v, _, limit) when v > limit, do: matrix

  defp generate(matrix, i, j, v, :right, limit) do
    case Matrix.get(matrix, i, j) do
      :undefined -> matrix |> Matrix.set(i, j, v) |> generate(i, j + 1, v + 1, :right, limit)
      _ -> matrix |> generate(i + 1, j - 1, v, :down, limit)
    end
  end

  defp generate(matrix, i, j, v, :down, limit) do
    case Matrix.get(matrix, i, j) do
      :undefined -> matrix |> Matrix.set(i, j, v) |> generate(i + 1, j, v + 1, :down, limit)
      _ -> matrix |> generate(i - 1, j - 1, v, :left, limit)
    end
  end

  defp generate(matrix, i, j, v, :left, limit) do
    case Matrix.get(matrix, i, j) do
      :undefined -> matrix |> Matrix.set(i, j, v) |> generate(i, j - 1, v + 1, :left, limit)
      _ -> matrix |> generate(i - 1, j + 1, v, :up, limit)
    end
  end

  defp generate(matrix, i, j, v, :up, limit) do
    case Matrix.get(matrix, i, j) do
      :undefined -> matrix |> Matrix.set(i, j, v) |> generate(i - 1, j, v + 1, :up, limit)
      _ -> matrix |> generate(i + 1, j + 1, v, :right, limit)
    end
  end
end

defmodule Matrix do
  alias __MODULE__
  defstruct [:content, :rows, :cols]

  defguardp is_valid_index(i, limit) when 0 <= i and i < limit
  defguardp is_valid_coords(m, i, j) when is_valid_index(i, m.rows) and is_valid_index(j, m.cols)

  def new(rows, cols) do
    fun = fn _, _ -> :array.new(fixed: true, size: cols) end

    matrix = :array.new(fixed: true, size: rows)

    %Matrix{rows: rows, cols: cols, content: :array.map(fun, matrix)}
  end

  def get(%Matrix{content: matrix} = m, i, j) when is_valid_coords(m, i, j) do
    row = :array.get(i, matrix)
    :array.get(j, row)
  end

  def get(_, _, _), do: :out_of_bounds

  def set(%Matrix{content: matrix} = m, i, j, v) when is_valid_coords(m, i, j) do
    row = :array.get(i, matrix)
    updated_row = :array.set(j, v, row)
    %Matrix{m | content: :array.set(i, updated_row, matrix)}
  end

  def set(_, _, _, _), do: :out_of_bounds

  def to_list(%Matrix{content: matrix}) do
    fun = fn _, a -> :array.to_list(a) end

    :array.map(fun, matrix)
    |> :array.to_list()
  end
end
