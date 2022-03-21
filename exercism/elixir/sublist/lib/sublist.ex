defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """

  def compare(a, b) do
    la = length(a)
    lb = length(b)

    cond do
      la == lb -> if equals(a, b), do: :equal, else: :unequal
      la > lb -> if contains(b, a, 0, lb, 0, 0, la), do: :superlist, else: :unequal
      la < lb -> if contains(a, b, 0, la, 0, 0, lb), do: :sublist, else: :unequal
    end
  end

  defp equals([], []), do: true

  defp equals([ha | ta], [hb | tb]) do
    if ha != hb, do: false, else: equals(ta, tb)
  end

  # defp contains(a, b, ia, la, ib, sb, lb)
  # ia -> current index of a; la -> length of a
  # ib -> current index of b; sb -> "virtual" start of b; lb -> length of b
  defp contains(_, _, ia, la, _, _, _) when ia >= la, do: true
  defp contains(_, _, ia, la, _, sb, lb) when la - ia > lb - sb, do: false

  defp contains(a, b, ia, la, ib, sb, lb) do
    if Enum.at(a, ia) === Enum.at(b, ib + sb) do
      contains(a, b, ia + 1, la, ib + 1, sb, lb)
    else
      contains(a, b, 0, la, 0, sb + 1, lb)
    end
  end
end
