# ----------------print------------
defmodule Print do
  def print(x) do
    print1(x)
    IO.puts("")
  end

  def print1(x) when is_number(x) do
    IO.write(x)
  end

  def print1(x) when is_atom(x) do
    IO.write(x)
  end

  def print1(x) when is_list(x) do
    print_formula(x)
  end

  def print_formula([]) do
    true
  end

  def print_formula(x) when is_number(x) do
    IO.write(x)
  end

  def print_formula(x) when is_atom(x) do
    IO.write(x)
  end

  def print_formula([:list, x]) do
    :io.write(x)
  end

  def print_formula([:matrix | x]) do
    print_matrix(x)
  end

  def print_formula([:log, x, y]) do
    IO.write(:log)
    IO.write("(")
    print_formula(x)
    IO.write(",")
    print_formula(y)
    IO.write(")")
  end

  def print_formula([:!, x]) do
    print_formula(x)
    IO.write("!")
  end

  def print_formula([operator, operand1, operand2]) do
    print_formula(operand1)
    IO.write(operator)
    print_formula(operand2)
  end

  def print_formula([:-, arg]) do
    IO.write(:-)
    print_formula(arg)
  end

  def print_formula([function, arg]) do
    IO.write(function)
    IO.write("(")
    print_formula(arg)
    IO.write(")")
  end

  def print_formula([function | args]) do
    IO.write(function)
    print_args(args)
  end

  def print_args([x]) do
    print_formula(x)
    IO.write(")")
  end

  def print_args([x | xs]) do
    print_formula(x)
    IO.write(",")
    print_args(xs)
  end

  def print_matrix([]) do
    true
  end

  def print_matrix([r | rs]) do
    :io.write(r)
    IO.puts("")
    print_matrix(rs)
  end
end
