defmodule Garden do
  @student_names ~w[
    alice
    bob
    charlie
    david
    eve
    fred
    ginny
    harriet
    ileana
    joseph
    kincaid
    larry
  ]a

  @types %{
    ?C => :clover,
    ?G => :grass,
    ?R => :radishes,
    ?V => :violets
  }

  @on_row 2

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @student_names) do
    children_map = Enum.reduce(student_names, %{}, fn name, names -> Map.put(names, name, {}) end)

    info_string
    |> String.split("\n")
    |> Enum.map(fn types -> types |> to_types() |> Enum.chunk_every(@on_row) end)
    |> Enum.zip()
    |> Enum.map(fn lists_tuple ->
      lists_tuple |> Tuple.to_list() |> List.flatten() |> List.to_tuple()
    end)
    |> then(fn grovings -> student_names |> Enum.sort() |> Enum.zip(grovings) end)
    |> Enum.into(%{})
    |> then(fn actual -> Map.merge(children_map, actual) end)
  end

  defp to_types(letters) do
    for <<ch <- letters>>, do: Map.get(@types, ch)
  end
end
