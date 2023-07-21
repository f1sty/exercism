defmodule KitchenCalculator do
  def get_volume({_unit, volume}), do: volume

  def to_milliliter({:milliliter, _volume} = volume_pair), do: volume_pair
  def to_milliliter({:cup, volume}), do: to_milliliter({:milliliter, volume * 240})
  def to_milliliter({:fluid_ounce, volume}), do: to_milliliter({:milliliter, volume * 30})
  def to_milliliter({:teaspoon, volume}), do: to_milliliter({:milliliter, volume * 5})
  def to_milliliter({:tablespoon, volume}), do: to_milliliter({:milliliter, volume * 15})

  def from_milliliter({:milliliter, _volume} = volume_pair, :milliliter),
    do: to_milliliter(volume_pair)

  def from_milliliter({:milliliter, volume}, :cup), do: {:cup, volume / 240}
  def from_milliliter({:milliliter, volume}, :fluid_ounce), do: {:fluid_ounce, volume / 30}
  def from_milliliter({:milliliter, volume}, :teaspoon), do: {:teaspoon, volume / 5}
  def from_milliliter({:milliliter, volume}, :tablespoon), do: {:tablespoon, volume / 15}

  def convert(volume_pair, unit) do
    volume_pair
    |> to_milliliter()
    |> from_milliliter(unit)
  end
end
