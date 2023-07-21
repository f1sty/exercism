defmodule RPG.CharacterSheet do
  def welcome() do
    IO.puts("Welcome! Let's fill out your character sheet together.")
  end

  def ask_name() do
    get_string("What is your character's name?\n")
  end

  def ask_class() do
    get_string("What is your character's class?\n")
  end

  def ask_level() do
    level = get_string("What is your character's level?\n")

    String.to_integer(level)
  end

  def run() do
    welcome()

    name = ask_name()
    class = ask_class()
    level = ask_level()
    character = %{name: name, class: class, level: level}

    IO.inspect(character, label: "Your character")
  end

  defp get_string(prompt) do
    input = IO.gets(prompt)

    String.trim(input)
  end
end
