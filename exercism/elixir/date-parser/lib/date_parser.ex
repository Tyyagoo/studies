defmodule DateParser do
  def day(), do: "((0{0,1}[1-9])|([1-2]\\d)|(3[0-1])){1,1}"

  def month(), do: "((0{0,1}[1-9])|(1[0-2])){1,1}"

  def year(), do: "\\d\\d\\d\\d"

  def day_names(), do: "(Sun|Mon|Tues|Wednes|Thurs|Fri|Satur)day"

  def month_names(),
    do:
      "(January|February|March|April|May|June|July|August|September|October|November|December){1,1}"

  def capture_day(), do: "(?<day>#{day()})"

  def capture_month(), do: "(?<month>#{month()})"

  def capture_year(), do: "(?<year>#{year()})"

  def capture_day_name(), do: "(?<day_name>#{day_names()})"

  def capture_month_name(), do: "(?<month_name>#{month_names()})"

  def capture_numeric_date(), do: "#{capture_day()}/#{capture_month()}/#{capture_year()}"

  def capture_month_name_date(), do: "#{capture_month_name()} #{capture_day()}, #{capture_year()}"

  def capture_day_month_name_date(), do: "#{capture_day_name()}, #{capture_month_name_date()}"

  def match_numeric_date(), do: Regex.compile!("^#{capture_numeric_date()}$")

  def match_month_name_date(), do: Regex.compile!("^#{capture_month_name_date()}$")

  def match_day_month_name_date(), do: Regex.compile!("^#{capture_day_month_name_date()}$")
end
