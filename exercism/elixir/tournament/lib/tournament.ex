defmodule Tournament do
  @default_team %{mp: 0, w: 0, d: 0, l: 0, p: 0}

  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> Enum.map(fn line -> line |> String.split(";") end)
    |> Enum.reduce(%{}, fn x, acc ->
      case x do
        [f, s, "win"] -> acc |> update_team(f, s, :win)
        [f, s, "loss"] -> acc |> update_team(s, f, :win)
        [f, s, "draw"] -> acc |> update_team(f, s, :draw)
        _ -> acc
      end
    end)
    |> print()
  end

  defp update_team(map, f, s, :draw) do
    map
    |> Map.put_new(f, @default_team)
    |> Map.put_new(s, @default_team)
    |> Map.update!(f, fn team ->
      %{mp: team.mp + 1, w: team.w, d: team.d + 1, l: team.l, p: team.p + 1}
    end)
    |> Map.update!(s, fn team ->
      %{mp: team.mp + 1, w: team.w, d: team.d + 1, l: team.l, p: team.p + 1}
    end)
  end

  defp update_team(map, winner, loser, :win) do
    map
    |> Map.put_new(winner, @default_team)
    |> Map.put_new(loser, @default_team)
    |> Map.update!(winner, fn team ->
      %{mp: team.mp + 1, w: team.w + 1, d: team.d, l: team.l, p: team.p + 3}
    end)
    |> Map.update!(loser, fn team ->
      %{mp: team.mp + 1, w: team.w, d: team.d, l: team.l + 1, p: team.p}
    end)
  end

  defp print(map) do
    map
    |> Enum.map(fn {k, v} -> {k, v} end)
    |> Enum.sort(fn {team_a, results_a}, {team_b, results_b} ->
      cond do
        results_a.p > results_b.p -> true
        results_a.p < results_b.p -> false
        true -> [team_a, team_b] |> Enum.sort() |> List.first() == team_a
      end
    end)
    |> Enum.reduce("Team                           | MP |  W |  D |  L |  P", fn {k, v}, acc ->
      acc <>
        "\n" <>
        String.pad_trailing(k, 31) <>
        "|  #{v.mp} |  #{v.w} |  #{v.d} |  #{v.l} | #{v.p |> Integer.to_string() |> String.pad_leading(2)}"
    end)
  end
end
