defmodule BasketballWebsite do
  def extract_from_path(data, path), do: extract(data, path |> String.split("."))

  defp extract(nil, _), do: nil
  defp extract(data, []), do: data
  defp extract(data, [head | tail]), do: extract(data[head], tail)

  def get_in_path(data, path), do: data |> Kernel.get_in(path |> String.split("."))
end
