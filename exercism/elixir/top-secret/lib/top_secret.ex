defmodule TopSecret do
  def to_ast(string), do: string |> Code.string_to_quoted!()

  def decode_secret_message_part({:def, _, _} = ast, acc), do: parse_function_def(ast, acc)
  def decode_secret_message_part({:defp, _, _} = ast, acc), do: parse_function_def(ast, acc)
  def decode_secret_message_part(ast, acc), do: {ast, acc}

  def decode_secret_message(string) do
    string
    |> to_ast()
    |> Macro.prewalk([], &decode_secret_message_part/2)
    |> (fn {_, acc} -> acc end).()
    |> Enum.reverse()
    |> Enum.join()
  end

  defp parse_function_def(ast, acc) do
    {atom, args} =
      case ast do
        {_, _, [{:when, _, [{name, _, args}, _]}, _]} -> {name, args}
        {_, _, [{name, _, args}, _]} -> {name, args}
      end

    {ast, [format_name(atom, args) | acc]}
  end

  defp format_name(atom, nil), do: format_name(atom, [])
  defp format_name(atom, args), do: atom |> Atom.to_string() |> String.slice(0, length(args))
end
