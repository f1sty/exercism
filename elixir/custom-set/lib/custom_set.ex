defmodule CustomSet do
  @opaque t :: %__MODULE__{elements: list}

  defstruct elements: []

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    struct(__MODULE__, elements: Enum.uniq(enumerable))
  end

  @spec empty?(t) :: boolean
  def empty?(custom_set) do
    Enum.empty?(custom_set.elements)
  end

  @spec contains?(t, any) :: boolean
  def contains?(custom_set, element) do
    element in custom_set.elements
  end

  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2) do
    custom_set_1.elements -- custom_set_2.elements == []
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2) do
    length(custom_set_1.elements -- custom_set_2.elements) == length(custom_set_1.elements)
  end

  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2) do
    Enum.sort(custom_set_1.elements) == Enum.sort(custom_set_2.elements)
  end

  @spec add(t, any) :: t
  def add(custom_set, element) do
    new([element | custom_set.elements])
  end

  @spec intersection(t, t) :: t
  def intersection(custom_set_1, custom_set_2) do
    elements =
      case length(custom_set_1.elements) < length(custom_set_2.elements) do
        true ->
          diff = custom_set_2.elements -- custom_set_1.elements
          custom_set_2.elements -- diff

        false ->
          diff = custom_set_1.elements -- custom_set_2.elements
          custom_set_1.elements -- diff
      end

    new(elements)
  end

  @spec difference(t, t) :: t
  def difference(custom_set_1, custom_set_2) do
    elements = custom_set_1.elements -- custom_set_2.elements
    new(elements)
  end

  @spec union(t, t) :: t
  def union(custom_set_1, custom_set_2) do
    new(custom_set_1.elements ++ custom_set_2.elements)
  end
end
