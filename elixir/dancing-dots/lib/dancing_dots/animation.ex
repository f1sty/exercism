defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts) :: {:ok, opts} | {:error, error}
  @callback handle_frame(dot, frame_number, opts) :: dot

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour DancingDots.Animation

      def init(opts) do
        {:ok, opts}
      end

      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(%DancingDots.Dot{opacity: opacity} = dot, frame_number, _opts) do
    case rem(frame_number, 4) == 0 do
      true -> %{dot | opacity: opacity / 2}
      false -> dot
    end
  end
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(opts) do
    velocity = Keyword.get(opts, :velocity)

    case is_number(velocity) do
      true ->
        {:ok, opts}

      false ->
        {:error,
         "The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(%DancingDots.Dot{radius: radius} = dot, frame_number, opts) do
    velocity = Keyword.get(opts, :velocity)

    %{dot | radius: radius + (frame_number - 1) * velocity}
  end
end
