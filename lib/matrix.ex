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

  def mult2([], _) do
    []
  end

  def mult2([x | xs], y) do
    [mult3(x, y) | mult2(xs, y)]
  end

  def mult3(_, []) do
    []
  end

  def mult3(x, [y | ys]) do
    [inner_product(x, y) | mult3(x, ys)]
  end

  def transpose([_ | x]) do
    [:matrix | transpose1(x)]
  end

  # [[1,2],    ->  [[1,3],
  #  [3,4]]         [2,4]]
  def transpose1(x) do
    transpose2(x, 1, col_length(x) + 1)
  end

  def transpose2(_, c, c) do
    []
  end

  def transpose2(x, n, c) do
    [col_vector(x, n) | transpose2(x, n + 1, c)]
  end

  def determinant([_ | x]) do
    determinant1(x)
  end

  def determinant1([[a, b], [c, d]]) do
    a * d - b * c
  end

  def determinant1(x) do
    size = length(x)

    for j <- 1..size do
      submatrix1(x, 1, j) |> determinant1() |> sign(x, 1, j)
    end
    |> Enum.sum()
  end

  def sign(x, m, i, j) do
    s = :math.pow(-1, i + j) |> round()
    s * elt(m, i, j) * x
  end

  def submatrix([_ | x], i, j) do
    [:matrix | submatrix1(x, i, j)]
  end

  def submatrix1([], _, _) do
    []
  end

  def submatrix1([_ | xs], 1, j) do
    submatrix1(xs, 0, j)
  end

  def submatrix1([x | xs], i, j) do
    [submatrix2(x, j) | submatrix1(xs, i - 1, j)]
  end

  def submatrix2([], _) do
    []
  end

  def submatrix2([_ | xs], 1) do
    xs
  end

  def submatrix2([x | xs], j) do
    [x | submatrix2(xs, j - 1)]
  end
end
