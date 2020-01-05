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

  def row_length(x) do
    length(x)
  end

  def col_length([x | _]) do
    length(x)
  end

  def elt(m, r, c) do
    Enum.at(m, r - 1) |> Enum.at(c - 1)
  end

  def raw_vector(x, r) do
    Enum.at(x, r - 1)
  end

  def col_vector([], _) do
    []
  end

  def col_vector([x | xs], c) do
    [Enum.at(x, c - 1) | col_vector(xs, c)]
  end

  def inner_product([], []) do
    0
  end

  def inner_product([x | xs], [y | ys]) do
    x * y + inner_product(xs, ys)
  end

  def mult([_ | x], [_ | y]) do
    cond do
      length(hd(x)) != length(y) -> Minima.error("Mismatch", [x, y])
      true -> [:matrix | mult1(x, y)]
    end
  end

  def mult1(x, y) do
    mult2(x, transpose1(y))
  end

  def mult2([],_) do [] end
  def mult2([x | xs], y) do
    [mult3(x, y) | mult2(xs, y)]
  end

  def mult3(_, []) do
    []
  end

  def mult3(x, [y | ys]) do
    [inner_product(x, y) | mult3(x, ys)]
  end

  def transpose([_| x]) do
    [:matrix | transpose1(x)]
  end

  # [[1,2],    ->  [[1,3],
  #  [3,4]]         [2,4]]
  def transpose1(x) do
    transpose2(x, 1, col_length(x)+1)
  end

  def transpose2(_, c, c) do
    []
  end

  def transpose2(x, n, c) do
    [col_vector(x, n) | transpose2(x, n + 1, c)]
  end
end
