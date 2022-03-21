defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    text
    |> String.to_charlist()
    |> do_rotate(shift, [])
    |> Enum.reverse()
    |> to_string()
  end

  defp do_rotate([], _, acc), do: acc

  defp do_rotate([head | tail], shift, acc) when head >= ?a and head <= ?z do
    cond do
      head + shift <= ?z -> do_rotate(tail, shift, [head + shift | acc])
      true -> do_rotate(tail, shift, [head + shift - ?z + ?a - 1 | acc])
    end
  end

  defp do_rotate([head | tail], shift, acc) when head >= ?A and head <= ?Z do
    cond do
      head + shift <= ?Z -> do_rotate(tail, shift, [head + shift | acc])
      true -> do_rotate(tail, shift, [head + shift - ?Z + ?A - 1 | acc])
    end
  end

  defp do_rotate([head | tail], shift, acc), do: do_rotate(tail, shift, [head | acc])
end
