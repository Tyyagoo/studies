defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts) :: {:ok, opts} | {:error, error}
  @callback handle_frame(dot, frame_number, opts) :: dot

  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)

      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  alias DancingDots.{Animation, Dot}
  use Animation

  @impl Animation
  def handle_frame(dot, frame_number, _opts) do
    if rem(frame_number, 4) == 0,
      do: %Dot{dot | opacity: dot.opacity / 2},
      else: dot
  end
end

defmodule DancingDots.Zoom do
  alias DancingDots.{Animation, Dot}
  use Animation

  @impl Animation
  def init(opts) do
    velocity = opts[:velocity]

    if is_number(velocity) do
      {:ok, opts}
    else
      {:error,
       "The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"}
    end
  end

  @impl Animation
  def handle_frame(dot, frame_number, opts) do
    velocity = Keyword.get(opts, :velocity, 0)
    %Dot{dot | radius: dot.radius + (frame_number - 1) * velocity}
  end
end
