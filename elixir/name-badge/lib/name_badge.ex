defmodule NameBadge do
  @joiner " - "

  def print(id, name, department) do
    id = if not is_nil(id), do: "[#{id}]"
    department = if is_nil(department), do: "OWNER", else: String.upcase(department)

    [id, name, department]
    |> Enum.join(@joiner)
    |> String.trim_leading(@joiner)
  end
end
