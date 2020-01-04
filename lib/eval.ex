defmodule Eval do
  def eval(:quit) do
    throw("goodbye")
  end

  def eval([:diff, fmla, arg]) do
    diff(fmla, arg)
  end

  def eval([:integrate, fmla, arg]) do
    integrate(fmla, arg)
  end

  def eval([:factori,x]) when is_integer(x) do
    prime_factorization(x)
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

  #-----------integral-------------------
  def integrate([:^,x,n],x) when is_integer(n) do
    [:*,[:/,1,n+1,],[:^,x,n+1]]
  end

  def integrate([:/,1,x],x) do
    [:log,:"%e",[:abs,x]]
  end

  def integrate([:sin, x], x) do
    [:-,[:cos, x]]
  end

  def integrate([:cos, x], x) do
    [:sin, x]
  end

  def integrate([:^,:"%e",x], x) do
    [:^,:"%e",x]
  end 

  #---------- composit function------------------
  def is_composit([_,arg1],x) when is_list(arg1) do
    is_composit1(arg1,x)
  end
  def is_composit([_,arg1,_],x) when is_list(arg1) do
    is_composit1(arg1,x)
  end 
  def is_composit([_,_,arg2],x) when is_list(arg2) do
    is_composit1(arg2,x)
  end 

  def is_composit1(x,x) do true end
  def is_composit1([_,arg1,arg2],x) do
    is_composit1(arg1,x) || is_composit1(arg2,x)
  end
  def is_composit1([_,arg1],x) do
    is_composit1(arg1,x)
  end
  def is_composit1(_,_) do false end


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

  def simple([:log,:"%e",1]) do
    0
  end
  def simple([:log,:"%e",:"%e"]) do
    1
  end
  def simple([:log,:"%e",x]) when is_float(x) do
    :math.log(x)
  end
  def simple([:sqrt,x]) when is_float(x) do
    :math.sqrt(x)
  end
  def simple([:sin,0]) do
    0
  end
  def simple([:sin,:"%pi"]) do
    0
  end
  def simple([:sin,[:/, :"%pi", 2]]) do
    1
  end
  def simple([:sin,x]) when is_float(x) do
    :math.sin(x)
  end
  def simple([:cos,0]) do
    1
  end
  def simple([:cos,:"%pi"]) do
    -1
  end
  def simple([:cos,[:/, :"%pi", 2]]) do
    0
  end
  def simple([:cos,x]) when is_float(x) do
    :math.cos(x)
  end

  def simple([:!,x]) when is_integer(x) do
    factorial(x)
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

  def factorial(0) do 1 end
  def factorial(n) do
    n * factorial(n-1)
  end

  def prime_factorization(n) do
    ls = prime_factorization1(2,:math.sqrt(n),n,[])
    |> compress()
    [:list,ls]
  end

  def prime_factorization1(fac,max,n,ls) do
     #IO.inspect binding()
    cond do
      fac > max -> [n|ls]
      rem(n,fac) == 0 -> prime_factorization1(fac,max,div(n,fac),[fac|ls])
      true -> if fac == 2 do 
                prime_factorization1(3,max,n,ls)
              else
                prime_factorization1(fac+2,max,n,ls)
              end
    end
  end 

  def compress(ls) do
    Enum.chunk_by(ls,fn(n) -> n end)
    |> Enum.map(fn(x) -> [hd(x),length(x)] end)
    |> Enum.reverse
  end
  
end

