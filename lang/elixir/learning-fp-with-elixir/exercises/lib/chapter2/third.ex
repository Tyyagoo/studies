defmodule Exercises.Chapter2.Third do
  @moduledoc """
  Build an anonymous function that applies a tax of 12% to a given price.
  It should print a message with the new price and tax value. Bind the
  anonymous function to a variable called apply_tax.
  """

  @doc """
  Show prices with taxes applied.
  
  Example:
    iex> import ExUnit.CaptureIO
    iex> capture_io(fn -> Exercises.Chapter2.Third.show([12.5, 30.99, 250.49, 18.80]) end)
    "Price: 12.5 - Tax: 1.5\\nPrice: 30.99 - Tax: 3.72\\nPrice: 250.49 - Tax: 30.06\\nPrice: 18.8 - Tax: 2.26\\n"
  """
  def show(prices) do
    apply_tax = fn price ->
      with_tax = price * 1.12
      IO.puts("Price: #{price} - Tax: #{Float.round(with_tax - price, 2)}")
      with_tax
    end

    prices |> Enum.each(apply_tax)
  end
end
