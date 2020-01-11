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
    assert capture_io(fn -> Minima.bar("diff(log(%e,x),x);\n") end) == "1/x\n"
    assert capture_io(fn -> Minima.bar("integrate(cos(x),x);\n") end) == "sin(x)\n"
    assert capture_io(fn -> Minima.bar("factori(1234);\n") end) == "[[2,1],[617,1]]\n"
    assert capture_io(fn -> Minima.bar("6/12;\n") end) == "1/2\n"
    assert capture_io(fn -> Minima.bar("log(%e,3.0);\n") end) == "1.0986122886681098\n"
    assert capture_io(fn -> Minima.bar("%pi;\n") end) == "3.141592653589793\n"
    assert capture_io(fn -> Minima.bar("10!;\n") end) == "3628800\n"
    assert capture_io(fn -> Minima.bar("sqrt(2.0);\n") end) == "1.4142135623730951\n"
    assert capture_io(fn -> Minima.bar("sin(%pi);\n") end) == "0\n"
    assert capture_io(fn -> Minima.bar("diff(sin(cos(x)),x);\n") end) == "cos(cos(x))*-sin(x)\n"
    # power law
    assert capture_io(fn -> Minima.bar("x^3*x^4;\n") end) == "x^7\n"
    assert capture_io(fn -> Minima.bar("x^10/x^3;\n") end) == "x^7\n"
    assert capture_io(fn -> Minima.bar("x*x^4;\n") end) == "x^5\n"
    assert capture_io(fn -> Minima.bar("x^3*x;\n") end) == "x^4\n"
    assert capture_io(fn -> Minima.bar("x^3/x;\n") end) == "x^2\n"
    assert capture_io(fn -> Minima.bar("x/x^3;\n") end) == "x^-2\n"
    # composit-function
    assert capture_io(fn -> Minima.bar("diff(sin(cos(x)),x);\n") end) == "cos(cos(x))*-sin(x)\n"
    # numerical
    assert capture_io(fn -> Minima.bar("1+2+3;\n") end) == "6\n"
    assert capture_io(fn -> Minima.bar("1+2-3;\n") end) == "0\n"
    assert capture_io(fn -> Minima.bar("1*3-2;\n") end) == "1\n"
    assert capture_io(fn -> Minima.bar("1*3/4;\n") end) == "3/4\n"

    # matrix
    m1 = "matrix([1,2],[3,4])"
    m2 = "matrix([3,4],[5,6])"
    m3 = "matrix([2,3,1],[5,7,8],[10,3,0])"
    assert capture_io(fn -> Minima.bar(m1 <> "+" <> m2 <> ";\n") end) == "[4,6]\n[8,10]\n\n"
    assert capture_io(fn -> Minima.bar(m1 <> "-" <> m2 <> ";\n") end) == "[-2,-2]\n[-2,-2]\n\n"
    assert capture_io(fn -> Minima.bar(m1 <> "*" <> m2 <> ";\n") end) == "[13,16]\n[29,36]\n\n"
    assert capture_io(fn -> Minima.bar("determinant(" <> m1 <> ");\n") end) == "-2\n"
    assert capture_io(fn -> Minima.bar("determinant(" <> m3 <> ");\n") end) == "137\n"

    assert capture_io(fn -> Minima.bar("invert(" <> m3 <> ");\n") end) ==
             "[-0.17518248175182483,0.021897810218978103,0.12408759124087591]\n[0.583941605839416,-0.072992700729927,-0.08029197080291971]\n[-0.40145985401459855,0.17518248175182483,-0.0072992700729927005]\n\n"

    assert capture_io(fn -> Minima.bar("adjoint(" <> m3 <> ");\n") end) ==
             "[-24,80,-55]\n[3,-10,24]\n[17,-11,-1]\n\n"

    # vector
    assert capture_io(fn -> Minima.bar("[1,2,3] . [1,2,3];\n") end) == "14\n"
  end
end
