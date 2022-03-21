defmodule Luhn do
  defguardp is_numerical(char) when ?0 <= char and char <= ?9

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(string) do
    with {:ok, numbers} <- parse(string, []),
         true <- length?(numbers),
         true <- checksum?(numbers) do
      true
    else
      _ -> false
    end
  end

  defp parse(<<char, rest::binary>>, acc) when is_numerical(char),
    do: parse(rest, [char - ?0 | acc])

  defp parse(<<char, rest::binary>>, acc) when char == ?\s, do: parse(rest, acc)
  defp parse(<<>>, acc), do: {:ok, acc}
  defp parse(_, _), do: {:error, :invalid_character}

  defp length?(numbers), do: length(numbers) > 1

  defp checksum?(numbers) do
    numbers
    |> Enum.with_index()
    |> Enum.reduce(0, fn
      {value, index}, acc when rem(index, 2) == 0 ->
        acc + value

      {value, _}, acc ->
        x = value * 2
        acc + if x >= 10, do: x - 9, else: x
    end)
    |> rem(10)
    |> Kernel.==(0)
  end
end
