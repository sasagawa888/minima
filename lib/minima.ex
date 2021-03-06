# data type
# formula [operator,operand...]
# function [function,arg...]
# vector [elt1,elt2...]
# matrix [:matrix,row1,row2...]
# list [:list, x]

defmodule Minima do
  def repl() do
    IO.puts("Minima ver0.01")
    repl1([], [])
  end

  defp repl1(buf, def) do
    try do
      IO.write("> ")
      {fmla, buf, _} = Read.parse([], [], [], [:";"])
      # IO.inspect(fmla)
      # Eval.eval(fmla) |> IO.inspect()
      {val, def1} = Eval.eval(fmla, def)
      val |> Eval.simple() |> Print.print()
      def2 = Keyword.put(def1, :%, val)
      repl1(buf, def2)
    catch
      x ->
        IO.puts(x)

        if x != "goodbye" do
          repl1(buf, def)
        else
          true
        end
    end
  end

  # Error
  def error(msg, x) do
    IO.write(msg)
    throw(x)
  end

  # for debug
  def stop() do
    raise "debug stop"
  end

  # for test
  def foo(x) do
    Read.parse([], [], Read.tokenize(x), [:";"])
  end

  def bar(x) do
    {fmla, _, _} = Read.parse([], [], Read.tokenize(x), [:";"])
    {val, _} = Eval.eval(fmla, [])
    val |> Eval.simple() |> Print.print()
  end

  # ----------common function--------------
  def is_operator(x) do
    Enum.member?([:+, :-, :*, :/, :^, :":", :.], x)
  end

  def is_fun([x | _]) do
    Enum.member?([:sin, :cos, :tan, :log, :exp, :sqrt], x)
  end

  def is_fun(_) do
    false
  end

  def is_heavy(x, _) when is_number(x) do
    false
  end

  def is_heavy(x, _) when is_atom(x) do
    false
  end

  def is_heavy([x | _], y) do
    if is_operator(x) && Minima.weight(x) > Minima.weight(y) do
      true
    else
      false
    end
  end

  def weight(:+) do
    100
  end

  def weight(:-) do
    100
  end

  def weight(:*) do
    50
  end

  def weight(:/) do
    50
  end

  def weight(:^) do
    30
  end

  def is_matrix([:matrix | _]) do
    true
  end

  def is_matrix(_) do
    false
  end

  def is_vector([x | _]) do
    if !is_operator(x) && !is_fun(x) do
      true
    else
      false
    end
  end

  def is_vector(_) do
    false
  end
end
