defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    b = String.downcase(base)
    step({b, String.split(b, "")}, candidates, [])
  end

  defp step(_, [], acc), do: acc |> Enum.reverse()

  defp step({base, lst}, [head | tail], acc) do
    candidate = String.downcase(head)

    if base != candidate and anagram?(lst, String.split(candidate, "")) do
      step({base, lst}, tail, [head | acc])
    else
      step({base, lst}, tail, acc)
    end
  end

  defp anagram?(word, candidate), do: Enum.frequencies(word) == Enum.frequencies(candidate)
end
