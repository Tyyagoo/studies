defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          {{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}
  def from({{year, month, day}, {hours, minutes, seconds}}) do
    datetime =
      NaiveDateTime.new!(year, month, day, hours, minutes, seconds)
      |> NaiveDateTime.add(1_000_000_000)

    %NaiveDateTime{
      year: yy,
      month: mm,
      day: dd,
      hour: h,
      minute: m,
      second: s
    } = datetime

    {{yy, mm, dd}, {h, m, s}}
  end
end
