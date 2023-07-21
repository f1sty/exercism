defmodule ProteinTranslation do
  @codon_to_protein_map %{
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
    Stream.resource(
      fn ->
        {:ok, pid} = StringIO.open(rna)
        pid
      end,
      fn pid ->
        case IO.read(pid, 3) do
          :eof -> {:halt, pid}
          data -> {[data], pid}
        end
      end,
      fn pid -> StringIO.close(pid) end
    )
    |> Enum.reduce_while({:ok, []}, fn codon, {:ok, proteins} ->
      case of_codon(codon) do
        {:ok, "STOP"} -> {:halt, {:ok, proteins}}
        {:ok, codon} -> {:cont, {:ok, proteins ++ [codon]}}
        {:error, _} -> {:halt, {:error, "invalid RNA"}}
      end
    end)
  end

  @doc """
  Given a codon, return the corresponding protein
  """
  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon) do
    if protein = Map.get(@codon_to_protein_map, codon),
      do: {:ok, protein},
      else: {:error, "invalid codon"}
  end
end
