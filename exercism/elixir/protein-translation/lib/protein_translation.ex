defmodule ProteinTranslation do
  @codon2protein %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UAA" => "STOP",
    "UAG" => "STOP",
    "UGA" => "STOP"
  }

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {:ok, list(String.t())} | {:error, String.t()}
  def of_rna(rna) do
    rna
    |> String.split("", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(&Enum.join/1)
    |> do_of_rna([])
  end

  defp do_of_rna([], acc), do: {:ok, Enum.reverse(acc)}

  defp do_of_rna([h | t], acc) do
    case of_codon(h) do
      {:error, _} -> {:error, "invalid RNA"}
      {:ok, "STOP"} -> do_of_rna([], acc)
      {:ok, protein} -> do_of_rna(t, [protein | acc])
    end
  end

  @doc """
  Given a codon, return the corresponding protein


  """
  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon) do
    case Map.get(@codon2protein, codon) do
      nil -> {:error, "invalid codon"}
      protein -> {:ok, protein}
    end
  end
end
