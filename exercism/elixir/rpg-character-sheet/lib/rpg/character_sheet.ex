defmodule RPG.CharacterSheet do
  def welcome(), do: IO.puts("Welcome! Let's fill out your character sheet together.")

  def ask_name(), do: ask("What is your character's name?")

  def ask_class(), do: ask("What is your character's class?")

  def ask_level(), do: ask("What is your character's level?") |> String.to_integer()

  defp ask(text), do: IO.gets(text <> "\n") |> String.trim()

  def run() do
    welcome()

    %{
      name: ask_name(),
      class: ask_class(),
      level: ask_level()
    }
    |> IO.inspect(label: "Your character")
  end
end
