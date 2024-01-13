defmodule Ledger do
  @doc """
  Format the given entries given a currency and locale
  """
  @type currency :: :usd | :eur
  @type locale :: :en_US | :nl_NL
  @type entry :: %{amount_in_cents: integer(), date: Date.t(), description: String.t()}

  @spec format_entries(currency(), locale(), list(entry())) :: String.t()
  def format_entries(currency, locale, entries) do
    header =
      case locale do
        :en_US -> "Date       | Description               | Change       \n"
        :nl_NL -> "Datum      | Omschrijving              | Verandering  \n"
      end

    header <>
      (entries
       |> Enum.sort_by(&{&1.date.day, &1.description, &1.amount_in_cents})
       |> Enum.map(&format_entry(currency, locale, &1))
       |> List.insert_at(-1, "")
       |> Enum.join("\n"))
  end

  defp format_entry(currency, locale, entry) do
    [year, month, day] = Date.to_string(entry.date) |> String.split("-")
    date = format_date(locale, day, month, year)
    description = format_description(entry.description)
    amount = format_currency(currency, locale, entry.amount_in_cents)
    "#{date}| #{description} |#{amount}"
  end

  defp format_date(:en_US, day, month, year), do: month <> "/" <> day <> "/" <> year <> " "
  defp format_date(:nl_NL, day, month, year), do: day <> "-" <> month <> "-" <> year <> " "

  defp format_description(description) do
    if String.length(description) > 26 do
      String.slice(description, 0, 22) <> "..."
    else
      String.pad_trailing(description, 25, " ")
    end
  end

  defp format_currency(currency, locale, amount_in_cents) do
    {thousand_separator, decimal_separator} =
      case locale do
        :en_US -> {",", "."}
        :nl_NL -> {".", ","}
      end

    cents =
      abs(amount_in_cents)
      |> rem(100)
      |> to_string()
      |> String.pad_leading(2, "0")

    whole =
      abs(amount_in_cents)
      |> div(100)
      |> to_string
      |> String.graphemes()
      |> Enum.reverse()
      |> Enum.chunk_every(3)
      |> Enum.map(&Enum.reverse/1)
      |> Enum.reverse()
      |> Enum.join(thousand_separator)

    number = whole <> decimal_separator <> cents
    symbol = if(currency == :eur, do: "€", else: "$")
    neg = amount_in_cents < 0

    case {locale, neg} do
      {:en_US, true} -> "(#{symbol}#{number})"
      {:en_US, false} -> "#{symbol}#{number} "
      {:nl_NL, true} -> "#{symbol} -#{number} "
      {:nl_NL, false} -> "#{symbol} #{number} "
    end
    |> String.pad_leading(14, " ")
  end
end