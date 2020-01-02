defmodule Eval do
  def eval(:quit) do
    throw("goodbye")
  end

  def eval([:diff, fmla, arg]) do
    diff(fmla, arg)
  end

  def eval([:integra, fmla, arg]) do
    integra(fmla, arg)
  end

  def eval(x) do
    simple(x)
  end

  #----------diffrential----------------------------
  # n -> 0
  def diff(n,_) when is_number(n) do
    0
  end

  # x -> 1
  def diff(x,x) when is_atom(x) do
    1
  end

  # x^n -> n*x^(n-1)
  def diff([:^, x, n], x) when is_integer(n) do
    [:*, n, [:^, x, n - 1]]
  end

  # n*x -> n
  def diff([:*, n, x], x) when is_integer(n) do
    n
  end

  # sin(x) -> cos(x)
  def diff([:sin, x], x) do
    [:cos, x]
  end

  # cos(x) -> -sin(x)
  def diff([:cos, x], x) do
    [:-, [:sin, x]]
  end

  # tan(x) -> 1/cos^2(x)
  def diff([:tan, x], x) do
    [:/, 1, [:^, [:cos, x], 2]]
  end

  #log(e,x) -> 1/x
  def diff([:log, :"%e", x], x) do
    [:/, 1, x]
  end

  #log(a,x) -> 1/(X*log(e,A))).
  def diff([:log, a, x], x) do
    [:/,1,[:*,x,[:log,:"%e",a]]]
  end

  # e^x -> e^x
  def diff([:^, :"%e", x], x) do
    [:^, :"%e", x]
  end

  # a^x -> a^x*log(e,x)
  def diff([:^, a, x], x) do
    [:*, [:^, a, x], [:log, "%e", a]]
  end
  # f1 + f2 -> (f1)'+(f2)'
  def diff([:+, f1, f2], x) do
    [:+, diff(f1, x), diff(f2, x)]
  end
  # f1 - f2 -> (f1)'-(f2)'
  def diff([:-, f1, f2], x) do
    [:-, diff(f1, x), diff(f2, x)]
  end

  #-----------integra-------------------
  def integra([:^,x,n],x) when is_integer(n) do
    [:*,[:/,1,n+1,],[:^,x,n+1]]
  end

  def integra([:/,1,x],x) do
    [:log,:"%e",[:abs,x]]
  end

  def integra([:sin, x], x) do
    [:-,[:cos, x]]
  end

  def integra([:cos, x], x) do
    [:sin, x]
  end

  def integra([:^,:"%e",x], x) do
    [:^,:"%e",x]
  end 

  

  #-----------simplify------------------------
  def simple(x) when is_number(x) do
    x
  end

  def simple(x) when is_atom(x) do
    cond do
      x == :"%pi" -> :math.pi()
      x == :"%e" -> :math.exp(1)
      true -> x
    end
  end

  def simple([:+, 0, x]) do
    simple(x)
  end

  def simple([:+, x, 0]) do
    simple(x)
  end

  def simple([:+, x, y]) do
    if is_number(x) && is_number(y) do
       x + y
    else
      x1 = simple(x)
      y1 = simple(y)
      cond do
        x1 == x && y1 == y -> [:+,x,y]
        x1 == x && y1 != y -> simple([:+,x,y1])
        x1 != x && y1 == y -> simple([:+,x1,y])
        true -> simple([:+, x1, y1])
      end
    end
  end

  def simple([:*, 0, _]) do
    0
  end

  def simple([:*, _, 0]) do
    0
  end

  def simple([:*, 1, x]) do
    simple(x)
  end

  def simple([:*, x, 1]) do
    simple(x)
  end

  def simple([:*, x, y]) do
    if is_number(x) && is_number(y) do
       x + y
    else
      x1 = simple(x)
      y1 = simple(y)
      cond do
        x1 == x && y1 == y -> [:*,x,y]
        x1 == x && y1 != y -> simple([:*,x,y1])
        x1 != x && y1 == y -> simple([:*,x1,y])
        true -> simple([:*, x1, y1])
      end
    end
  end


  def simple([:^, _, 0]) do
    1
  end

  def simple([:^, x, 1]) do
    x
  end

  def simple([:^, x, y]) do
    if is_number(x) && is_number(y) do
       x + y
    else
      x1 = simple(x)
      y1 = simple(y)
      cond do
        x1 == x && y1 == y -> [:^,x,y]
        x1 == x && y1 != y -> simple([:^,x,y1])
        x1 != x && y1 == y -> simple([:^,x1,y])
        true -> simple([:^, x1, y1])
      end
    end
  end

  def simple(x) do
    x
  end

  def power(x, y) do
    cond do
      y == 1 -> x
      rem(y, 2) == 0 -> power(x * x, div(y, 2))
      true -> x * power(x, y - 1)
    end
  end
end
