defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    path = split_path(path)

    Enum.reduce(path, data, fn key, value -> Access.get(value, key) end)
  end

  def get_in_path(data, path) do
    path = split_path(path)

    get_in(data, path)
  end

  defp split_path(path), do: String.split(path, ".", trim: true)
end
