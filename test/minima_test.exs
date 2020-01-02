defmodule MinimaTest do
  use ExUnit.Case
  doctest Minima

  
  test "parse" do
    assert Minima.foo("x+y;") == {[:+, :x, :y], [], :";"}
    assert Minima.foo("x^3+2*x+1;") == {[:+, [:+, [:^, :x, 3], [:*, 2, :x]], 1], [], :";"}
  end

end
 