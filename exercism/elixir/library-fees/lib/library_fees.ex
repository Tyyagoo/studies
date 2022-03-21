defmodule LibraryFees do
  def datetime_from_string(string) do
    case NaiveDateTime.from_iso8601(string) do
      {:ok, datetime} -> datetime
      _ -> "ixi"
    end
  end

  def before_noon?(datetime) do
    datetime.hour < 12
  end

  def return_date(checkout_datetime) do
    days = if before_noon?(checkout_datetime), do: 28, else: 29
    checkout_datetime
    |> NaiveDateTime.add(days * 86400, :seconds)
    |> NaiveDateTime.to_date()
  end

  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_datetime
    |> NaiveDateTime.to_date()
    |> Date.diff(planned_return_date)
    |> (fn diff -> if diff < 0, do: 0, else: diff end).()
  end

  def monday?(datetime) do
    datetime
    |> NaiveDateTime.to_date()
    |> Date.day_of_week()
    |> case do
      1 -> true
      _ -> false
    end
  end

  def calculate_late_fee(checkout, return, rate) do
    checkout = checkout |> datetime_from_string()
    return = return |> datetime_from_string()
    checkout
    |> return_date()
    |> days_late(return)
    |> (fn days -> days * rate end).()
    |> (fn fee -> if monday?(return), do: Float.floor(fee / 2), else: fee end).()
  end
end
