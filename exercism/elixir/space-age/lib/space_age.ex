defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @planets %{
    mercury: 0.2408467,
    venus: 0.61519726,
    mars: 1.8808158,
    jupiter: 11.862615,
    saturn: 29.447498,
    uranus: 84.016846,
    neptune: 164.79132
  }

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'.
  """
  @spec age_on(planet, pos_integer) :: {:ok, float()} | {:error, String.t()}
  def age_on(:earth, seconds), do: {:ok, seconds / 31_557_600}

  def age_on(planet, seconds) do
    {:ok, age_on_earth} = age_on(:earth, seconds)

    case Map.fetch(@planets, planet) do
      {:ok, rate} -> {:ok, age_on_earth / rate}
      :error -> {:error, "not a planet"}
    end
  end
end
