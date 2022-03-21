defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    do_conversion(number, [])
  end

  defp do_conversion(number, acc) do
    cond do
      number >= 1000 -> do_conversion(number - 1000, ["M" | acc])
      number >= 900 -> do_conversion(number - 900, ["CM" | acc])
      number >= 500 -> do_conversion(number - 500, ["D" | acc])
      number >= 400 -> do_conversion(number - 400, ["CD" | acc])
      number >= 100 -> do_conversion(number - 100, ["C" | acc])
      number >= 90 -> do_conversion(number - 90, ["XC" | acc])
      number >= 50 -> do_conversion(number - 50, ["L" | acc])
      number >= 40 -> do_conversion(number - 40, ["XL" | acc])
      number >= 10 -> do_conversion(number - 10, ["X" | acc])
      number >= 9 -> do_conversion(number - 9, ["IX" | acc])
      number >= 5 -> do_conversion(number - 5, ["V" | acc])
      number >= 4 -> do_conversion(number - 4, ["IV" | acc])
      number >= 1 -> do_conversion(number - 1, ["I" | acc])
      true -> acc |> Enum.reduce(&<>/2)
    end
  end
end
