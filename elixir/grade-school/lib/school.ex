defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @type school :: list()

  @doc """
  Create a new, empty school.
  """
  @spec new() :: school
  def new(), do: []

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(school, String.t(), integer) :: {:ok | :error, school}
  def add(school, name, grade) do
    case Enum.find(school, fn {n, _} -> name == n end) do
      nil -> {:ok, [{name, grade} | school]}
      _ -> {:error, school}
    end
  end

  @doc """
  Return the names of the students in a particular grade, sorted alphabetically.
  """
  @spec grade(school, integer) :: [String.t()]
  def grade(school, grade) do
    school
    |> Enum.filter(fn {_, g} -> g == grade end)
    |> Enum.sort()
    |> Enum.map(&elem(&1, 0))
  end

  @doc """
  Return the names of all the students in the school sorted by grade and name.
  """
  @spec roster(school) :: [String.t()]
  def roster(school) do
    school
    |> Enum.group_by(fn {_, grade} -> grade end, fn {name, _} -> name end)
    |> Enum.sort()
    |> Enum.flat_map(fn {_grade, names} -> Enum.sort(names) end)
  end
end
