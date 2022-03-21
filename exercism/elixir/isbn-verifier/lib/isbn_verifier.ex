defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    with lst <- String.to_charlist(isbn),
         {:ok, values} <- parse(lst, 0, []),
         sum <- calculate(values, 1, 0),
         true <- check?(sum) do
      true
    else
      _ -> false
    end
  end

  defp parse([h | t], size, acc) when ?0 <= h and h <= ?9, do: parse(t, size + 1, [h - ?0 | acc])
  defp parse([?X | []], 9, acc), do: parse([], 10, [10 | acc])
  defp parse([?- | t], size, acc), do: parse(t, size, acc)

  defp parse([], 10, acc), do: {:ok, acc}
  defp parse([], _, _), do: {:error, :invalid_length}
  defp parse(_, _, _), do: {:error, :invalid_character}

  defp calculate([h | t], mult, acc), do: calculate(t, mult + 1, acc + h * mult)
  defp calculate([], _, acc), do: acc

  defp check?(value), do: rem(value, 11) == 0
end
