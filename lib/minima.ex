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
end
