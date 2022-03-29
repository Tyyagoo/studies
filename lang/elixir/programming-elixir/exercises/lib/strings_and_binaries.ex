defmodule StringsAndBinaries do
  @doc """
  Write a function that returns true if a single-quoted string contains only
  printable ASCII characters (space through tilde).
  
  ## Examples:
  
      iex> import StringsAndBinaries
      StringsAndBinaries
      iex> printable?([97, 115, 112, 97, 115])
      true
      iex> printable?([97, 115, 0, 112, 97, 115])
      false
  """
  @spec printable?(charlist) :: boolean
  def printable?([hd | tl]) when hd in ?\s..?~, do: printable?(tl)
  def printable?([]), do: true
  def printable?(_), do: false

  @doc """
  Write an anagram?(word1, word2) that returns true if its parameters are
  anagrams.
  
  ## Examples:
  
      iex> import StringsAndBinaries
      StringsAndBinaries
      iex> anagram?('snow', 'Owns')
      true
      iex> anagram?('stop', 'stop')
      false
  """
  @spec anagram?(charlist, charlist) :: boolean
  def anagram?(word1, word2) do
    downcase =
      &Enum.map(&1, fn
        char when char in ?A..?Z -> char + (?a - ?A)
        char -> char
      end)

    freq = &Enum.frequencies/1

    word1 = downcase.(word1)
    word2 = downcase.(word2)

    cond do
      word1 == word2 -> false
      true -> freq.(word1) == freq.(word2)
    end
  end

  # Try the following in IEx:
  # iex> [ 'cat' | 'dog' ]
  # ['cat',100,111,103]
  # Why does IEx print 'cat' as a string, but 'dog' as individual numbers?

  # Answer: It's because 'cat' is prepended into the existing 'dog' charlist
  # So, 'dog' isn't anymore composed only by printable characters, because
  # it haves a list inside it.
  # That way, 'dog' can't be treated as a charlist, but 'cat' remains
  # unchanged and will be printed normally.

  @doc """
  (Hard) Write a function that takes a single-quoted string of the form
  number [+-*/] number and returns the result of the calculation.
  The individual numbers do not have leading plus or minus signs.
  
  ## Examples:
  
      iex> import StringsAndBinaries
      StringsAndBinaries
      iex> calculate('123 + 27')
      150
      iex> calculate('5 * 20')
      100
  """
  @spec calculate(charlist) :: integer
  def calculate(charlist), do: evaluate(charlist, nil, [[]])

  defp evaluate([], op, [y, x | _]),
    do: apply_op(op, parse_number(x, 1, 0), parse_number(y, 1, 0))

  defp evaluate([hd | tl], op, [n | acc]) when hd in ?0..?9,
    do: evaluate(tl, op, [[hd | n] | acc])

  defp evaluate([hd | tl], _op, acc) when hd in [?+, ?-, ?*, ?/],
    do: evaluate(tl, hd, [[] | acc])

  defp evaluate([_ | tl], op, acc), do: evaluate(tl, op, acc)

  defp parse_number([hd | tl], magnitude, acc),
    do: parse_number(tl, magnitude * 10, acc + (hd - ?0) * magnitude)

  defp parse_number([], _, acc), do: acc

  defp apply_op(?+, x, y), do: x + y
  defp apply_op(?-, x, y), do: x - y
  defp apply_op(?*, x, y), do: x * y
  defp apply_op(?/, x, y), do: x / y

  @doc ~S"""
  Write a function that takes a list of double-quoted strings and prints each
  on a separate line, centered in a column that has the width of the longest
  string. Make sure it works with UTF characters.
  
  ## Examples:
  
      iex> import StringsAndBinaries
      StringsAndBinaries
      iex> center(["zebra", "cat", "elephant"])
      "  cat   \n zebra  \nelephant"
  """
  @spec center([String.t()]) :: String.t()
  def center(strings) do
    sorted_strings = Enum.sort_by(strings, &String.length/1, &>=/2)
    longest = hd(sorted_strings)
    base_len = String.length(longest)

    sorted_strings
    |> Enum.map(fn str ->
      len = String.length(str)
      whitespaces = base_len - len
      half = div(whitespaces, 2)

      str
      |> String.pad_leading(len + half)
      |> String.pad_trailing(len + 2 * half + rem(whitespaces, 2))
    end)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  @doc """
  Write a function to capitalize the sentences in a string. Each sentence is
  terminated by a period and a space. Right now, the case of the characters
  in the string is random.
  
  ## Examples:
  
      iex> import StringsAndBinaries
      StringsAndBinaries
      iex> capitalize_sentences("oh. a DOG. woof. ")
      "Oh. A dog. Woof. "
  """
  @spec capitalize_sentences(String.t()) :: String.t()
  def capitalize_sentences(string), do: do_capitalize(string, true, <<>>)

  @offset ?a - ?A
  defp do_capitalize(<<head::utf8, rest::binary>>, upcase?, acc) do
    cond do
      head in ?a..?z ->
        normalized = if upcase?, do: head - @offset, else: head
        do_capitalize(rest, false, <<acc::binary, normalized::utf8>>)

      head in ?A..?Z ->
        normalized = if upcase?, do: head, else: head + @offset
        do_capitalize(rest, false, <<acc::binary, normalized::utf8>>)

      head == ?. ->
        do_capitalize(rest, true, <<acc::binary, head::utf8>>)

      true ->
        do_capitalize(rest, upcase?, <<acc::binary, head::utf8>>)
    end
  end

  defp do_capitalize(<<>>, _, acc), do: acc

  @doc """
  Chapter 7 had an exercise about calculating sales tax on page 114. We
  now have the sales information in a file of comma-separated id, ship_to,
  and amount values. The file looks like this:
  id,ship_to,net_amount
  123,:NC,100.00
  124,:OK,35.50
  125,:TX,24.00
  126,:TX,44.80
  127,:NC,25.00
  128,:MA,10.00
  129,:CA,102.00
  120,:NC,50.00
  
  ## Examples:
  
      iex> import StringsAndBinaries
      StringsAndBinaries
      iex> bookshelf("test/fixtures/bookshelf.csv")
      [
        [id: 123, ship_to: :NC, net_amount: 100.0, total_amount: 107.5],
        [id: 124, ship_to: :OK, net_amount: 35.5, total_amount: 35.5],
        [id: 125, ship_to: :TX, net_amount: 24.0, total_amount: 25.92],
        [id: 126, ship_to: :TX, net_amount: 44.8, total_amount: 48.384],
        [id: 127, ship_to: :NC, net_amount: 25.0, total_amount: 26.875],
        [id: 128, ship_to: :MA, net_amount: 10.0, total_amount: 10.0],
        [id: 129, ship_to: :CA, net_amount: 102.0, total_amount: 102.0],
        [id: 120, ship_to: :NC, net_amount: 50.0, total_amount: 53.75]
      ]
  """
  @spec bookshelf(Path.t()) :: Keyword.t()
  def bookshelf(path) do
    path
    |> Path.expand()
    |> File.stream!()
    |> Stream.drop(1)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(fn [str_id, str_ship_to, str_net] ->
      id = String.to_integer(str_id)
      ship_to = str_ship_to |> String.replace(":", "") |> String.to_atom()
      net = String.to_float(str_net)
      [id: id, ship_to: ship_to, net_amount: net]
    end)
    |> Enum.to_list()
    |> StreamsAndComprehensions.bookshelf(NC: 0.075, TX: 0.08)
  end
end
