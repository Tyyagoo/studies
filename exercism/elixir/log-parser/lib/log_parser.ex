defmodule LogParser do
  def valid_line?(line), do: String.match?(line, ~r/^\[(DEBUG|INFO|WARNING|ERROR)\]/)

  def split_line(line), do: String.split(line, ~r/<[~*=\-]*>/, trim: true)

  def remove_artifacts(line), do: String.replace(line, ~r/end-of-line\d+/i, "")

  def tag_with_user_name(line) do
    case Regex.run(~r/User\s+(\S*)/, line) do
      [_match, username] -> "[USER] " <> username <> " " <> line
      nil -> line
    end
  end
end
