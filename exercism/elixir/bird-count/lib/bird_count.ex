defmodule BirdCount do
  @spec today(list()) :: non_neg_integer() | nil
  def today([]), do: nil
  def today([head | _]), do: head

  @spec increment_day_count(list()) :: list()
  def increment_day_count([]), do: [1]
  def increment_day_count([head | tail]), do: [head + 1 | tail]

  @spec has_day_without_birds?(list()) :: boolean()
  def has_day_without_birds?([]), do: false
  def has_day_without_birds?([head | tail]) when head != 0, do: has_day_without_birds?(tail)
  def has_day_without_birds?(_), do: true

  @spec total(list()) :: non_neg_integer()
  def total(list), do: do_total(list, 0)

  @spec busy_days(list()) :: non_neg_integer()
  def busy_days(list), do: do_busy_days(list, 0)

  defp do_total([], acc), do: acc
  defp do_total([head | tail], acc), do: do_total(tail, acc + head)

  defp do_busy_days([], acc), do: acc
  defp do_busy_days([head | tail], acc) when head >= 5, do: do_busy_days(tail, acc + 1)
  defp do_busy_days([_ | tail], acc), do: do_busy_days(tail, acc)
end
