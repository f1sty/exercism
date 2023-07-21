defmodule SquareRoot do
  @doc """
  Calculate the square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: float
  def calculate(radicand) do
    calculate(radicand, radicand / 2)
  end

  # Using Heron's method here, please read
  # https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Heron's_method for more
  # details.
  defp calculate(radicand, x0) do
    xn = (x0 + radicand / x0) / 2

    (xn === x0 && xn) || calculate(radicand, xn)
  end
end
