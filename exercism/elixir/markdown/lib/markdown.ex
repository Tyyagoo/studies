defmodule Markdown do
  @type markdown :: String.t()
  @type html :: String.t()
  # here `|` hasn't sense of union, but of intersection
  @typep partial :: markdown() | html()

  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"
  """
  @spec parse(markdown()) :: html()
  def parse(markdown) do
    markdown
    |> String.split("\n")
    |> Enum.map(&process/1)
    |> Enum.join()
    |> patch()
  end

  @spec process(markdown()) :: html()
  defp process(line) do
    cond do
      String.starts_with?(line, "#") && !String.starts_with?(line, "#######") ->
        line |> parse_header_md_level() |> enclose_with_header_tag()

      String.starts_with?(line, "*") ->
        parse_list_md_level(line)

      true ->
        line |> String.split() |> enclose_with_paragraph_tag()
    end
  end

  @spec parse_header_md_level(markdown()) :: {String.t(), String.t()}
  defp parse_header_md_level(header_line) do
    [heading_tokens | text_list] = String.split(header_line)
    heading_level = heading_tokens |> String.length() |> to_string()
    {heading_level, Enum.join(text_list, " ")}
  end

  @spec parse_list_md_level(markdown()) :: html()
  defp parse_list_md_level(list_line) do
    item_text =
      list_line
      |> String.trim_leading("* ")
      |> String.split()
      |> join_words_with_tags()

    "<li>" <> item_text <> "</li>"
  end

  @spec enclose_with_header_tag({String.t(), String.t()}) :: html()
  defp enclose_with_header_tag({heading_level, text}) do
    "<h#{heading_level}>#{text}</h#{heading_level}>"
  end

  @spec enclose_with_paragraph_tag([markdown()]) :: html()
  defp enclose_with_paragraph_tag(words) do
    "<p>#{join_words_with_tags(words)}</p>"
  end

  @spec join_words_with_tags([markdown()]) :: html()
  defp join_words_with_tags(words) do
    words
    |> Enum.map(&replace_md_with_tag/1)
    |> Enum.join(" ")
  end

  @spec replace_md_with_tag(markdown()) :: html()
  defp replace_md_with_tag(word) do
    word
    |> replace_prefix_md()
    |> replace_suffix_md()
  end

  @spec replace_prefix_md(markdown()) :: partial()
  defp replace_prefix_md(word) do
    cond do
      word =~ ~r/^__/ -> String.replace(word, ~r/^__/, "<strong>", global: false)
      word =~ ~r/^_/ -> String.replace(word, ~r/^_/, "<em>", global: false)
      true -> word
    end
  end

  @spec replace_suffix_md(partial()) :: html()
  defp replace_suffix_md(word) do
    cond do
      word =~ ~r/__$/ -> String.replace(word, ~r/__$/, "</strong>")
      word =~ ~r/_$/ -> String.replace(word, ~r/_$/, "</em>")
      true -> word
    end
  end

  @spec patch(html()) :: html()
  defp patch(html) do
    String.replace(html, "<li>", "<ul><li>", global: false)
    |> String.reverse()
    |> String.replace(String.reverse("</li>"), String.reverse("</li></ul>"), global: false)
    |> String.reverse()
  end
end
