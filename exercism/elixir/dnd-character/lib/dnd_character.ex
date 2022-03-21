defmodule DndCharacter do
  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec modifier(pos_integer()) :: integer()
  def modifier(score), do: Float.floor((score - 10) / 2) |> trunc()

  @spec ability :: pos_integer()
  def ability do
    0..3
    |> Enum.map(fn _ -> :rand.uniform(6) end)
    |> Enum.sort(&>=/2)
    |> Enum.take(3)
    |> Enum.reduce(&+/2)
  end

  @spec character :: t()
  def character do
    constitution = ability()

    %__MODULE__{
      strength: ability(),
      dexterity: ability(),
      constitution: constitution,
      intelligence: ability(),
      wisdom: ability(),
      charisma: ability(),
      hitpoints: 10 + modifier(constitution)
    }
  end
end
