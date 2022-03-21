defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @day_of_week [
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  ]

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    Date.new(year, month, 1)
    |> (fn {:ok, date} -> date end).()
    |> find_meetup(weekday, schedule)
  end

  defp find_meetup(date, weekday, :last) do
    date
    |> Date.end_of_month()
    |> find_weekday(@day_of_week[weekday], &Date.add(&1, -1))
  end

  defp find_meetup(date, weekday, :teenth) do
    date
    |> find_meetup(weekday, :last)
    |> case do
      d = %Date{day: day} when day - 7 >= 20 -> Date.add(d, -14)
      d -> Date.add(d, -7)
    end
  end

  defp find_meetup(date, weekday, schedule) do
    d = find_weekday(date, @day_of_week[weekday], &Date.add(&1, 1))

    case schedule do
      :first -> d
      :second -> Date.add(d, 7)
      :third -> Date.add(d, 14)
      :fourth -> Date.add(d, 21)
    end
  end

  defp find_weekday(date, weekday, dir) do
    cond do
      Date.day_of_week(date) == weekday -> date
      true -> date |> dir.() |> find_weekday(weekday, dir)
    end
  end
end
