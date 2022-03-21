defmodule Newsletter do
  defp map(data, fun) do
    case data do
      {:ok, value} -> fun.(value)
      _ -> data
    end
  end

  def read_emails(path) do
    path
    |> File.read()
    |> map(fn value ->
      value
      |> String.split("\n")
      |> Enum.drop(-1)
    end)
  end

  def open_log(path), do: File.open!(path, [:write])

  def log_sent_email(pid, email), do: IO.puts(pid, email)

  def close_log(pid), do: File.close(pid)

  def send_newsletter(emails_path, log_path, send_fun) do
    log = open_log(log_path)

    emails_path
    |> read_emails()
    |> send_emails(send_fun, log)

    close_log(log)
  end

  defp send_emails([], _, _), do: nil

  defp send_emails([head | tail], send_fun, log) do
    if send_fun.(head) == :ok, do: log_sent_email(log, head)
    send_emails(tail, send_fun, log)
  end
end
