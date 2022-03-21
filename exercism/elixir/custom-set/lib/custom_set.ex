defmodule CustomSet do
  defstruct map: %{}
  @opaque t :: %__MODULE__{map: map}

  @spec new(Enum.t()) :: t
  def new(enum), do: %__MODULE__{map: Enum.into(enum, %{}, &{&1, true})}

  @spec empty?(t) :: boolean
  def empty?(custom_set), do: Enum.count(custom_set.map) == 0

  @spec contains?(t, any) :: boolean
  def contains?(custom_set, element), do: Map.get(custom_set.map, element, false)

  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2) do
    l1 = Enum.count(custom_set_1.map)
    l2 = Enum.count(custom_set_2.map)

    cond do
      l1 == l2 -> equal?(custom_set_1, custom_set_2)
      l1 > l2 -> false
      l1 < l2 -> intersection(custom_set_1, custom_set_2) |> equal?(custom_set_1)
    end
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2),
    do: intersection(custom_set_1, custom_set_2) |> empty?()

  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2), do: custom_set_1.map == custom_set_2.map

  @spec add(t, any) :: t
  def add(custom_set, element), do: %__MODULE__{map: Map.put(custom_set.map, element, true)}

  @spec intersection(t, t) :: t
  def intersection(custom_set_1, custom_set_2) do
    custom_set_1.map
    |> Enum.filter(fn {k, _} -> contains?(custom_set_2, k) end)
    |> Enum.map(fn {k, _} -> k end)
    |> new()
  end

  @spec difference(t, t) :: t
  def difference(custom_set_1, custom_set_2) do
    (Map.keys(custom_set_1.map) -- Map.keys(custom_set_2.map))
    |> new()
  end

  @spec union(t, t) :: t
  def union(custom_set_1, custom_set_2) do
    (Map.keys(custom_set_1.map) ++ Map.keys(custom_set_2.map))
    |> new()
  end
end
