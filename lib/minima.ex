defmodule Minima do
  def repl() do
    IO.puts("Minima ver0.01")
    repl1([])
  end

  defp repl1(buf) do
    try do
      IO.write("> ")
      {fmla, buf, _} = Read.parse([], [], [], [:";"])
      #Eval.eval(fmla) |> IO.inspect()
      Eval.eval(fmla) |> Eval.simple() |> Print.print()
      repl1(buf)
    catch
      x ->
        IO.puts(x)

        if x != "goodbye" do
          repl1(buf)
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
    Read.parse([],[],Read.tokenize(x),[:";"])
  end

  #----------common function--------------
  def is_operator(x) do
    Enum.member?([:+, :-, :*, :/, :^], x)
  end

  def is_function([x|_]) do
    Enum.member?([:sin,:cos,:tan,:log,:exp,:sqrt],x)
  end

  def is_heavy(x,_) when is_number(x) do false end
  def is_heavy(x,_) when is_atom(x) do false end
  def is_heavy([x|_],y) do
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
end
