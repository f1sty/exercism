defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception([]) do
      %StackUnderflowError{}
    end

    @impl true
    def exception(ctx) do
      %StackUnderflowError{message: "stack underflow occurred, context: #{ctx}"}
    end
  end

  def divide(stack) when length(stack) < 2 do
    raise StackUnderflowError, "when dividing"
  end

  def divide([0 | _rest]) do
    raise DivisionByZeroError
  end

  def divide([divisor, divident | _]) do
    div(divident, divisor)
  end
end
