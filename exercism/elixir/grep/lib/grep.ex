defmodule Grep do
  @typep line :: {content :: String.t(), line_number :: pos_integer()}
  @typep parsed_file :: {file_name :: String.t(), matched_lines :: [line]}

  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    match_fun = parse_match_flags(flags, pattern)

    files
    |> Stream.map(&{&1, File.read!(&1)})
    |> Stream.map(fn {filename, data} -> {filename, String.split(data, "\n", trim: true)} end)
    |> Stream.map(fn {filename, lines} -> {filename, match_lines(lines, match_fun)} end)
    |> Enum.to_list()
    |> format_result!(flags)
  catch
    "" -> ""
    result -> if String.ends_with?(result, "\n"), do: result, else: result <> "\n"
  end

  @spec parse_match_flags([String.t()], String.t()) :: (String.t() -> boolean())
  defp parse_match_flags(flags, pattern) do
    match_x = if "-x" in flags, do: &==/2, else: &String.contains?/2

    match_i =
      if "-i" in flags,
        do: &match_x.(String.downcase(&1), String.downcase(pattern)),
        else: &match_x.(&1, pattern)

    match_v = if "-v" in flags, do: &(not match_i.(&1)), else: match_i
    match_v
  end

  @spec match_lines([String.t()], (String.t() -> boolean())) :: [line]
  defp match_lines(lines, match_fun) do
    lines
    |> Enum.with_index(1)
    |> Enum.reduce([], fn {line, line_number}, acc ->
      if match_fun.(line), do: [{line, line_number} | acc], else: acc
    end)
    |> Enum.reverse()
  end

  @spec format_result!([parsed_file], [String.t()]) :: nil
  defp format_result!(matches, flags) do
    if "-l" in flags do
      matches
      |> Enum.filter(fn {_, lst} -> lst != [] end)
      |> Enum.map(fn {filename, _} -> filename end)
      |> Enum.join("\n")
      |> throw()
    end

    join_n = if "-n" in flags, do: fn {l, n} -> "#{n}:#{l}" end, else: fn {l, _} -> l end

    join_info =
      if length(matches) > 1,
        do: &"#{&1}:#{join_n.(&2)}",
        else: fn _, line -> join_n.(line) end

    matches
    |> Enum.filter(fn {_, lst} -> lst != [] end)
    |> Enum.map(fn {filename, matched_lines} ->
      matched_lines
      |> Enum.map(&join_info.(filename, &1))
      |> Enum.join("\n")
    end)
    |> Enum.join("\n")
    |> throw()
  end
end
