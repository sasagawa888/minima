defmodule Matrix do
  def add([_ | x], [_ | y]) do
    cond do
      length(x) != length(y) -> Minima.error("Mismatch", [x, y])
      length(hd(x)) != length(hd(y)) -> Minima.error("Mismatch", [x, y])
      true -> [:matrix | add1(x, y)]
    end
  end

  def add1([], []) do
    []
  end

  def add1([x | xs], [y | ys]) do
    [add2(x, y) | add1(xs, ys)]
  end

  def add2([], _) do
    []
  end

  def add2([x | xs], [y | ys]) do
    [x + y | add2(xs, ys)]
  end

  def sub([_ | x], [_ | y]) do
    cond do
      length(x) != length(y) -> Minima.error("Mismatch", [x, y])
      length(hd(x)) != length(hd(y)) -> Minima.error("Mismatch", [x, y])
      true -> [:matrix | sub1(x, y)]
    end
  end

  def sub1([], []) do
    []
  end

  def sub1([x | xs], [y | ys]) do
    [sub2(x, y) | sub1(xs, ys)]
  end

  def sub2([], _) do
    []
  end

  def sub2([x | xs], [y | ys]) do
    [x - y | sub2(xs, ys)]
  end

  def elt(m,r,c) do
      Enum.at(m,r-1) |> Enum.at(c-1)
  end 

  def raw_vector(x,r) do
    Enum.at(x,r-1)
  end

  def col_vector([],_) do [] end
  def col_vector([x|xs],c) do
    [Enum.at(x,c-1)|col_vector(xs,c)]
  end

  def inner_product([],[]) do 1 end
  def inner_product([x|xs],[y|ys]) do
    x*y + inner_product(xs,ys)
  end

  def mult([_ | x], [_ | y]) do
    cond do
      length(hd(x)) != length(y) -> Minima.error("Mismatch", [x, y])
      true -> [:matrix | mult1(x, y)]
    end
  end
  
  def mult1(_,_) do [] end

end
