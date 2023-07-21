defmodule LogLevel do
  @code_to_label_map %{
    0 => :trace,
    1 => :debug,
    2 => :info,
    3 => :warning,
    4 => :error,
    5 => :fatal
  }

  @codes_absent_in_legacy [0, 5]

  def to_label(code, legacy?) do
    cond do
      legacy? and code in @codes_absent_in_legacy -> :unknown
      true -> Map.get(@code_to_label_map, code, :unknown)
    end
  end

  def alert_recipient(code, legacy?) do
    level = to_label(code, legacy?)

    cond do
      level in [:error, :fatal] -> :ops
      level === :unknown and legacy? -> :dev1
      level === :unknown -> :dev2
      true -> false
    end
  end
end
