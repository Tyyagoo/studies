defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    number
    |> Integer.digits()
    |> (fn digits ->
          len = length(digits)
          Enum.reduce(digits, 0, fn n, acc -> acc + Integer.pow(n, len) end)
        end).()
    |> Kernel.==(number)
  end
end
