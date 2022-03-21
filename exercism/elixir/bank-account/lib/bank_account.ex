defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @account_closed_error {:error, :account_closed}

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = Agent.start_link(fn -> %{balance: 0, status: :open} end)
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: :ok
  def close_bank(account) do
    Agent.update(account, fn s -> %{s | status: :closed} end)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    Agent.get(account, fn
      %{balance: balance, status: :open} -> balance
      _ -> @account_closed_error
    end)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    Agent.get_and_update(account, fn
      %{status: :open} = s -> {:ok, %{s | balance: s.balance + amount}}
      s -> {@account_closed_error, s}
    end)
  end
end
