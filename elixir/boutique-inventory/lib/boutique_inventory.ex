defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    Enum.sort_by(inventory, & &1.price)
  end

  def with_missing_price(inventory) do
    Enum.filter(inventory, &is_nil(&1.price))
  end

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, &%{&1 | name: String.replace(&1.name, old_word, new_word)})
  end

  def increase_quantity(%{quantity_by_size: qty_by_size} = item, count) do
    %{item | quantity_by_size: Enum.into(qty_by_size, %{}, fn {k, v} -> {k, v + count} end)}
  end

  def total_quantity(%{quantity_by_size: qty_by_size}) do
    Enum.reduce(qty_by_size, 0, fn {_size, qty}, total -> total + qty end)
  end
end
