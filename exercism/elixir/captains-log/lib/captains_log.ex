defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  def random_planet_class(), do: @planetary_classes |> Enum.random()

  def random_ship_registry_number(), do: "NCC-#{Enum.random(1000..9999)}"

  def random_stardate(), do: :rand.uniform() * 999 + 41000.0

  def format_stardate(stardate), do: :io_lib.format("~.1f", [stardate]) |> List.to_string()
end
