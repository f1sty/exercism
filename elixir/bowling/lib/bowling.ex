defmodule Bowling do
  @pins 10

  defstruct pins: @pins,
            scores: [],
            frames: [],
            throw: 1

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start do
    %__MODULE__{}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """

  @spec roll(any, integer) :: {:ok, any} | {:error, String.t()}
  def roll(_game, roll) when roll < 0, do: {:error, "Negative roll is invalid"}

  def roll(%__MODULE__{pins: pins}, roll) when roll > pins,
    do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%__MODULE__{throw: throw, frames: [:spare | _] = frames} = game, roll)
      when length(frames) == 10 and throw <= 21 do
    throw = throw + 1
    scores = [roll | game.scores]
    pins = if roll == 10, do: 10, else: game.pins - roll

    {:ok, %{game | pins: pins, scores: scores, throw: throw}}
  end

  def roll(%__MODULE__{throw: throw, frames: [:strike | _] = frames} = game, roll)
      when length(frames) == 10 and throw <= 22 do
    throw = throw + 1
    scores = [roll | game.scores]
    pins = if roll == 10, do: 10, else: game.pins - roll

    {:ok, %{game | pins: pins, scores: scores, throw: throw}}
  end

  def roll(%__MODULE__{frames: [:open | _] = frames}, _roll) when length(frames) == 10,
    do: {:error, "Cannot roll after game is over"}

  def roll(%__MODULE__{frames: [:spare | _] = frames, throw: throw}, _roll)
      when length(frames) == 10 and throw > 21,
      do: {:error, "Cannot roll after game is over"}

  def roll(%__MODULE__{frames: [:strike | _] = frames, throw: throw}, _roll)
      when length(frames) == 10 and throw > 22,
      do: {:error, "Cannot roll after game is over"}

  def roll(%__MODULE__{throw: throw, frames: [_ | rest]} = game, roll)
      when rem(throw, 2) == 0 do
    frame_type = if game.pins == roll, do: :spare, else: :open
    throw = throw + 1
    scores = [roll | game.scores]
    frames = [frame_type | rest]

    {:ok, %{game | pins: @pins, frames: frames, scores: scores, throw: throw}}
  end

  def roll(%__MODULE__{throw: throw, frames: frames} = game, 10 = roll)
      when rem(throw, 2) != 0 do
    frame_type = :strike
    throw = throw + 2
    scores = [roll | game.scores]
    frames = [frame_type | frames]

    {:ok, %{game | pins: @pins, frames: frames, scores: scores, throw: throw}}
  end

  def roll(%__MODULE__{throw: throw, frames: frames} = game, roll) do
    throw = throw + 1
    scores = [roll | game.scores]
    frames = [nil | frames]
    pins = game.pins - roll

    {:ok, %{game | pins: pins, frames: frames, scores: scores, throw: throw}}
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful error tuple.
  """

  @spec score(any) :: {:ok, integer} | {:error, String.t()}
  def score(%__MODULE__{frames: frames}) when length(frames) < 10,
    do: {:error, "Score cannot be taken until the end of the game"}

  def score(%__MODULE__{scores: scores, frames: frames}) do
    frames = Enum.reverse(frames)
    scores = Enum.reverse(scores)

    answer =
      frames
      |> Enum.with_index()
      |> Enum.reduce({0, scores}, fn
        {:open, _}, {sum, [a, b | scores]} ->
          sum = sum + a + b

          {sum, scores}

        {:spare, _}, {sum, [a, b, c | scores]} ->
          sum = sum + a + b + c
          scores = [c | scores]

          {sum, scores}

        {:spare, 9}, {_sum, scores} when length(scores) <= 2 ->
          {:error, "Score cannot be taken until the end of the game"}

        {:strike, _}, {sum, [a, b, c | scores]} ->
          sum = sum + a + b + c
          scores = [b, c | scores]

          {sum, scores}

        {:strike, 9}, {_sum, scores} when length(scores) <= 2 ->
          {:error, "Score cannot be taken until the end of the game"}
      end)

    case answer do
      {:error, _} = msg -> msg
      {sum, _score} -> {:ok, sum}
    end
  end
end
