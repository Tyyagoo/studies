defmodule Username do
  def sanitize(username) do
    username
    |> Enum.map(fn char ->
      case char do
        ?ä -> 'ae'
        ?ö -> 'oe'
        ?ü -> 'ue'
        ?ß -> 'ss'
        _ -> char
      end
    end)
    |> List.flatten()
    |> Enum.filter(&((?a <= &1 and &1 <= ?z) or &1 == ?_))
  end
end
