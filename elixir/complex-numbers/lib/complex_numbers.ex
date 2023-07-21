defmodule ComplexNumbers do
  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {float, float}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: float
  def real({a, _b}), do: a

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: float
  def imaginary({_a, b}), do: b

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | float, b :: complex | float) :: complex
  def mul({a, b}, {c, d}) do
    a_new = a * c - b * d
    b_new = a * d + b * c

    {a_new, b_new}
  end

  def mul(a, {c, d}) when is_number(a), do: mul({a, 0}, {c, d})
  def mul({a, b}, c), do: mul({a, b}, {c, 0})

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | float, b :: complex | float) :: complex
  def add({a, b}, {c, d}), do: {a + c, b + d}
  def add(a, {c, d}) when is_number(a), do: add({a, 0}, {c, d})
  def add({a, b}, c), do: add({a, b}, {c, 0})

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | float, b :: complex | float) :: complex
  def sub({a, b}, {c, d}), do: {a - c, b - d}
  def sub(a, {c, d}) when is_number(a), do: sub({a, 0}, {c, d})
  def sub({a, b}, c), do: sub({a, b}, {c, 0})

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | float, b :: complex | float) :: complex
  def div({a, b}, {c, d}) do
    a_new = (a * c + b * d) / (c ** 2 + d ** 2)
    b_new = (b * c - a * d) / (c ** 2 + d ** 2)

    {a_new, b_new}
  end

  def div(a, {c, d}) when is_number(a), do: __MODULE__.div({a, 0}, {c, d})
  def div({a, b}, c), do: __MODULE__.div({a, b}, {c, 0})

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: float
  def abs({a, b}) do
    :math.sqrt(a ** 2 + b ** 2)
  end

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({a, b}), do: {a, -b}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp({a, b}) do
    a_new = :math.exp(a) * :math.cos(b)
    b_new = :math.exp(a) * :math.sin(b)

    {a_new, b_new}
  end
end
