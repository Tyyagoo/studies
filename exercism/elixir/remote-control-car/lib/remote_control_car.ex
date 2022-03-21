defmodule RemoteControlCar do
  @enforce_keys [:nickname, :distance_driven_in_meters, :battery_percentage]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          nickname: String.t(),
          distance_driven_in_meters: non_neg_integer(),
          battery_percentage: non_neg_integer()
        }

  @spec new(String.t()) :: t()
  def new(nickname \\ "none") do
    %__MODULE__{
      nickname: nickname,
      distance_driven_in_meters: 0,
      battery_percentage: 100
    }
  end

  @spec display_distance(t()) :: String.t()
  def display_distance(%__MODULE__{distance_driven_in_meters: distance}) do
    "#{distance} meters"
  end

  @spec display_battery(t()) :: String.t()
  def display_battery(%__MODULE__{battery_percentage: 0}) do
    "Battery empty"
  end

  def display_battery(%__MODULE__{battery_percentage: battery}) do
    "Battery at #{battery}%"
  end

  @spec drive(t()) :: t()
  def drive(%__MODULE__{battery_percentage: 0} = car) do
    car
  end

  def drive(%__MODULE__{} = car) do
    %__MODULE__{
      car
      | distance_driven_in_meters: car.distance_driven_in_meters + 20,
        battery_percentage: car.battery_percentage - 1
    }
  end
end
