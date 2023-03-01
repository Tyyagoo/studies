defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    input
    |> Enum.chunk_every(4)
    |> Enum.map(&pack_number/1)
    |> Enum.map(fn x -> Enum.map(x, &match/1) end)
    |> Enum.reduce_while([], fn line, acc ->
      line
      |> reduce_line()
      |> ok(&{:cont, [&1 | acc]}, &{:halt, &1})
    end)
    |> ok(&{:ok, Enum.reverse(&1) |> Enum.join(",")})
  end

  defp pack_number(line) do
    line
    |> Enum.map(&(String.graphemes(&1) |> Enum.chunk_every(3)))
    |> Enum.zip()
    |> Enum.map(fn n -> Tuple.to_list(n) |> Enum.map(&Enum.join/1) end)
  end

  defp match([" _ ", "| |", "|_|", "   "]), do: {:ok, "0"}
  defp match(["   ", "  |", "  |", "   "]), do: {:ok, "1"}
  defp match([" _ ", " _|", "|_ ", "   "]), do: {:ok, "2"}
  defp match([" _ ", " _|", " _|", "   "]), do: {:ok, "3"}
  defp match(["   ", "|_|", "  |", "   "]), do: {:ok, "4"}
  defp match([" _ ", "|_ ", " _|", "   "]), do: {:ok, "5"}
  defp match([" _ ", "|_ ", "|_|", "   "]), do: {:ok, "6"}
  defp match([" _ ", "  |", "  |", "   "]), do: {:ok, "7"}
  defp match([" _ ", "|_|", "|_|", "   "]), do: {:ok, "8"}
  defp match([" _ ", "|_|", " _|", "   "]), do: {:ok, "9"}
  defp match([<<_, _, _>>, <<_, _, _>>, <<_, _, _>>, <<_, _, _>>]), do: {:ok, "?"}
  defp match([_, _, _, _]), do: {:error, "invalid column count"}
  defp match(_), do: {:error, "invalid line count"}

  defp reduce_line(line) do
    Enum.reduce_while(line, "", fn
      {:ok, val}, acc -> {:cont, acc <> val}
      {:error, _} = error, _acc -> {:halt, error}
    end)
  end

  defp ok(result, on_success, on_fail \\ & &1)
  defp ok({:error, _} = error, _on_success, on_fail), do: on_fail.(error)
  defp ok({:ok, val}, on_success, _on_fail), do: on_success.(val)
  defp ok(val, on_success, _on_fail), do: on_success.(val)
end
