defmodule MinimaTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Minima

  test "parse" do
    assert Minima.foo("x+y;") == {[:+, :x, :y], [], :";"}
    assert Minima.foo("x^3+2*x+1;") == {[:+, [:+, [:^, :x, 3], [:*, 2, :x]], 1], [], :";"}
  end

  test "total test" do
    assert capture_io(fn -> Minima.bar("diff(x^2,x);\n") end) == "2*x\n"
    assert capture_io(fn -> Minima.bar("diff(x^2+1,x);\n") end) == "2*x\n"
    assert capture_io(fn -> Minima.bar("diff(x^2+2*x+1,x);\n") end) == "2*x+2\n"
    assert capture_io(fn -> Minima.bar("diff(x^3+2*x+3,x);\n") end) == "3*x^2+2\n"
    assert capture_io(fn -> Minima.bar("integrate(cos(x),x);\n") end) == "sin(x)\n"
    assert capture_io(fn -> Minima.bar("factori(1234);\n") end) == "[[2,1],[617,1]]\n"
    assert capture_io(fn -> Minima.bar("6/12;\n") end) == "1/2\n"
    assert capture_io(fn -> Minima.bar("sqrt(2.0);\n") end) == "1.4142135623730951\n"
    assert capture_io(fn -> Minima.bar("sin(%pi);\n") end) == "0\n"
  end 
end
