defmodule ZebraPuzzle do
  @colors ~w(ivory green red blue yellow) |> Enum.map(&String.to_atom/1)
  @nationalities ~w(spaniard japanese englishman ukrainian norwegian)
                 |> Enum.map(&String.to_atom/1)
  @drinks ~w(orange_juice coffee milk tea water) |> Enum.map(&String.to_atom/1)
  @smokes ~w(lucky_strike parliament old_gold chesterfield kools) |> Enum.map(&String.to_atom/1)
  @pets ~w(dog zebra snails horse fox) |> Enum.map(&String.to_atom/1)

  @doc """
  Determine who drinks the water
  """
  @spec drinks_water() :: atom
  def drinks_water() do
    solve()
    |> Enum.find(fn house -> house[:drink] == :water end)
    |> Map.get(:nationality)
  end

  @doc """
  Determine who owns the zebra
  """
  @spec owns_zebra() :: atom
  def owns_zebra() do
    solve()
    |> Enum.find(fn house -> house[:pet] == :zebra end)
    |> Map.get(:nationality)
  end

  defp solve() do
    possibilities =
      generate_possibilities()
      |> filter_by_general_rules([&r2/1, &r3/1, &r4/1, &r5/1, &r7/1, &r8/1, &r13/1, &r14/1])
      # performance hacky, since the right first house is the last one to be tested in normal flow
      |> Enum.reverse()

    # assert that the backtracking doesn't depends on input order, only for testing purposes
    # |> Enum.shuffle()

    possibilities
    # Applying rule 9, 10 and 15
    |> Enum.filter(fn
      %{drink: :milk} -> false
      %{color: :blue} -> false
      %{nationality: :norwegian} -> true
      _ -> false
    end)
    |> find_house(possibilities, 0, [])
  end

  # Generate all possibilities, 5 ^ 5 -> 3125
  defp generate_possibilities() do
    for color <- @colors,
        nationality <- @nationalities,
        drink <- @drinks,
        smoke <- @smokes,
        pet <- @pets do
      %{color: color, nationality: nationality, drink: drink, smoke: smoke, pet: pet}
    end
  end

  # Filter by general rules (pair rules), reduces 3125 to 95
  @spec filter_by_general_rules(possibilities :: list(), filters :: list()) :: list()
  defp filter_by_general_rules(possibilities, [hd | tl]) do
    possibilities
    |> Enum.filter(hd)
    |> filter_by_general_rules(tl)
  end

  defp filter_by_general_rules(possibilities, []), do: possibilities

  # Returns false when some house contains exactly one expected property, true otherwise
  @spec desired_pair(pair1 :: tuple(), pair2 :: tuple()) :: boolean()
  defp desired_pair({actual1, expected1}, {actual2, expected2}) do
    cond do
      actual1 == expected1 and actual2 == expected2 -> true
      actual1 == expected1 or actual2 == expected2 -> false
      true -> true
    end
  end

  # Find all 5 houses recursively
  @spec find_house(
          specific_possibilities :: list(),
          all_possibilities :: list(),
          house_count :: non_neg_integer(),
          acc :: list()
        ) :: list() | atom()
  defp find_house(_, _, 5, acc) do
    # Applying remaining rules to check if the result is right

    # Rule 6 - The green house is immediately to the right of the ivory house.
    r6_1 = Enum.find_index(acc, fn %{color: color} -> color == :green end)
    r6_2 = Enum.find_index(acc, fn %{color: color} -> color == :ivory end)
    r6 = r6_2 - r6_1 == 1

    # Rule 11 - The man who smokes Chesterfields lives in the house next to the man with the fox.
    r11_1 = Enum.find_index(acc, fn %{smoke: smoke} -> smoke == :chesterfield end)
    r11_2 = Enum.find_index(acc, fn %{pet: pet} -> pet == :fox end)
    r11 = abs(r11_1 - r11_2) == 1

    # Rule 12 - Kools are smoked in the house next to the house where the horse is kept.
    r12_1 = Enum.find_index(acc, fn %{smoke: smoke} -> smoke == :kools end)
    r12_2 = Enum.find_index(acc, fn %{pet: pet} -> pet == :horse end)
    r12 = abs(r12_1 - r12_2) == 1

    if r6 and r11 and r12, do: acc, else: :dead_end
  end

  defp find_house([hd | tl], all_poss, house_count, acc) do
    new_acc = [hd | acc]

    all_poss
    |> filter_by_duplicates_props(new_acc)
    |> filter_by_specific_house(house_count + 1, hd)
    |> find_house(all_poss, house_count + 1, new_acc)
    |> case do
      :dead_end -> find_house(tl, all_poss, house_count, acc)
      acc -> acc
    end
  end

  defp find_house([], _, _, _), do: :dead_end

  # filter possibilities for this house taking into account all previous houses
  @spec filter_by_duplicates_props(possibilities :: list, previous_houses :: list()) :: list()
  defp filter_by_duplicates_props(possibilities, [hd | tl]) do
    %{color: color, nationality: nationality, drink: drink, smoke: smoke, pet: pet} = hd

    possibilities
    |> Enum.filter(fn
      %{color: ^color} -> false
      %{nationality: ^nationality} -> false
      %{drink: ^drink} -> false
      %{smoke: ^smoke} -> false
      %{pet: ^pet} -> false
      _ -> true
    end)
    |> filter_by_duplicates_props(tl)
  end

  defp filter_by_duplicates_props(possibilities, []), do: possibilities

  @spec filter_by_specific_house(
          possibilities :: list(),
          house_count :: non_neg_integer(),
          last_house :: map()
        ) :: list()

  # Rule 15 - The Norwegian lives next to the blue house.
  defp filter_by_specific_house(possibilities, _, %{nationality: :norwegian}) do
    possibilities
    |> Enum.filter(fn %{color: color} -> color == :blue end)
  end

  # Rule 9 - Milk is drunk in the middle house.
  defp filter_by_specific_house(possibilities, 2, _) do
    possibilities
    |> Enum.filter(fn %{drink: drink} -> drink == :milk end)
  end

  defp filter_by_specific_house(possibilities, _, _), do: possibilities

  # Rule 2 - The Englishman lives in the red house.
  defp r2(%{color: color, nationality: nationality}),
    do: desired_pair({color, :red}, {nationality, :englishman})

  # Rule 3 - The Spaniard owns the dog.
  defp r3(%{nationality: nationality, pet: pet}),
    do: desired_pair({nationality, :spaniard}, {pet, :dog})

  # Rule 4 - Coffee is drunk in the green house.
  defp r4(%{color: color, drink: drink}),
    do: desired_pair({color, :green}, {drink, :coffee})

  # Rule 5 - The Ukrainian drinks tea.
  defp r5(%{nationality: nationality, drink: drink}),
    do: desired_pair({nationality, :ukrainian}, {drink, :tea})

  # Rule 7 - The Old Gold smoker owns snails.
  defp r7(%{smoke: smoke, pet: pet}),
    do: desired_pair({smoke, :old_gold}, {pet, :snails})

  # Rule 8 - Kools are smoked in the yellow house.
  defp r8(%{color: color, smoke: smoke}),
    do: desired_pair({color, :yellow}, {smoke, :kools})

  # Rule 13 - The Lucky Strike smoker drinks orange juice.
  defp r13(%{drink: drink, smoke: smoke}),
    do: desired_pair({drink, :orange_juice}, {smoke, :lucky_strike})

  # Rule 14 - The Japanese smokes Parliaments.
  defp r14(%{nationality: nationality, smoke: smoke}),
    do: desired_pair({nationality, :japanese}, {smoke, :parliament})
end
