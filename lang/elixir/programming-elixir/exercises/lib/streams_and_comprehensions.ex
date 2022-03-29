defmodule StreamsAndComprehensions do
  import ListsAndRecursion, only: [span: 2]

  @doc """
  In the last exercise of Chapter 7, Lists and Recursion, on page 71, you
  wrote a span function. Use it and list comprehensions to return a list of
  the prime numbers from 2 to n.
  
  ## Examples:
  
      iex> import StreamsAndComprehensions
      StreamsAndComprehensions
      iex> primes(25)
      [2, 3, 5, 7, 11, 13, 17, 19, 23]
  """
  def primes(n) when n >= 2 do
    prime? = fn
      2 ->
        true

      x ->
        span(2, x)
        |> Enum.all?(&(rem(x, &1) != 0))
    end

    for x <- span(2, n + 1), prime?.(x), do: x
  end

  @doc """
  The Pragmatic Bookshelf has offices in Texas (TX) and North Carolina
  (NC), so we have to charge sales tax on orders shipped to these states.
  The rates can be expressed as a keyword list.
  
  Write a function that takes both lists and returns a copy of the orders,
  but with an extra field, total_amount, which is the net plus sales tax. If a
  shipment is not to NC or TX, there’s no tax applied.
  
  ## Examples:
  
    iex> tax_rates = [ NC: 0.075, TX: 0.08 ]
    iex> orders = [
    ...>  [ id: 123, ship_to: :NC, net_amount: 100.00 ],
    ...>  [ id: 124, ship_to: :OK, net_amount: 35.50 ],
    ...>  [ id: 125, ship_to: :TX, net_amount: 24.00 ],
    ...>  [ id: 126, ship_to: :TX, net_amount: 44.80 ],
    ...>  [ id: 127, ship_to: :NC, net_amount: 25.00 ],
    ...>  [ id: 128, ship_to: :MA, net_amount: 10.00 ],
    ...>  [ id: 129, ship_to: :CA, net_amount: 102.00 ],
    ...>  [ id: 130, ship_to: :NC, net_amount: 50.00 ]
    ...> ]
    iex> StreamsAndComprehensions.bookshelf(orders, tax_rates)
    [
      [id: 123, ship_to: :NC, net_amount: 100.0, total_amount: 107.5],
      [id: 124, ship_to: :OK, net_amount: 35.5, total_amount: 35.5],
      [id: 125, ship_to: :TX, net_amount: 24.0, total_amount: 25.92],
      [id: 126, ship_to: :TX, net_amount: 44.8, total_amount: 48.384],
      [id: 127, ship_to: :NC, net_amount: 25.0, total_amount: 26.875],
      [id: 128, ship_to: :MA, net_amount: 10.0, total_amount: 10.0],
      [id: 129, ship_to: :CA, net_amount: 102.0, total_amount: 102.0],
      [id: 130, ship_to: :NC, net_amount: 50.0, total_amount: 53.75]
    ]
  """
  def bookshelf(orders, tax_rates) do
    # ??????
    orders
    |> Enum.map(fn order ->
      net = Keyword.get(order, :net_amount)
      ship_to = Keyword.get(order, :ship_to)
      tax = Keyword.get(tax_rates, ship_to, 0.0)

      order ++ [total_amount: net + net * tax]
    end)
  end
end
