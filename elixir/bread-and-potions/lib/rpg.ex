defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  defprotocol Edible do
    def eat(item, character)
  end

  defimpl Edible, for: LoafOfBread do
    def eat(_item, %{health: health} = character), do: {nil, %{character | health: health + 5}}
  end

  defimpl Edible, for: ManaPotion do
    def eat(%{strength: mana}, %{mana: old_mana} = character),
      do: {%EmptyBottle{}, %{character | mana: old_mana + mana}}
  end

  defimpl Edible, for: Poison do
    def eat(_item, character), do: {%EmptyBottle{}, %{character | health: 0}}
  end
end
