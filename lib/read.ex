defmodule Read do
  # parse formula
  # arg1 is operand
  # arg2 is operator
  # arg3 is token buffer list
  # arg4 is terminal list e.g. [:";]
  # return value {formula,rest-buffer,terminal-charactor}
  def parse([], [], buf, term) do
    # IO.inspect binding()
    {s, buf1} = read(buf)

    cond do
      Enum.member?(term, s) -> {s, buf1, s}
      Minima.is_operator(s) -> parse([], [s], buf1, term)
      true -> parse([s], [], buf1, term)
    end
  end

  def parse([operand1], [], buf, term) do
    # IO.inspect binding()
    {s, buf1} = read(buf)

    cond do
      Enum.member?(term, s) -> {operand1, buf1, s}
      Minima.is_operator(s) -> parse([operand1], [s], buf1, term)
      true -> Minima.error("Error: illegal formula1 ", s)
    end
  end

  def parse([operand1], [operator1], buf, term) do
    # IO.inspect binding()
    {s, buf1} = read(buf)

    cond do
      Minima.is_operator(s) -> Minima.error("Error: illegal formula2 ", [s])
      true -> parse([s, operand1], [operator1], buf1, term)
    end
  end

  def parse([operand1, operand2], [operator1], buf, term) do
    # IO.inspect binding()
    {s, buf1} = read(buf)

    cond do
      Enum.member?(term, s) ->
        {[operator1, operand2, operand1], buf1, s}

      Minima.is_operator(s) && Minima.weight(s) >= Minima.weight(operator1) ->
        parse([[operator1, operand2, operand1]], [s], buf1, term)

      Minima.is_operator(s) && Minima.weight(s) < Minima.weight(operator1) ->
        parse([operand1, operand2], [s, operator1], buf1, term)

      true ->
        Minima.error("Error: illegal formula3 ", s)
    end
  end

  def parse([operand1, operand2], [operator1, operator2], buf, term) do
    # IO.inspect binding()
    {s, buf1} = read(buf)

    cond do
      Enum.member?(term, s) -> Minima.error("Error: illegal formula4 ", s)
      Minima.is_operator(s) -> Minima.error("Error: illegal formula5 ", s)
      true -> parse([[operator2, operand2, [operator1, operand1, s]]], [], buf1, term)
    end
  end

  def read([]) do
    buf = IO.gets("") |> tokenize()
    read(buf)
  end

  def read(["" | xs]) do
    read(xs)
  end

  # terminal char
  def read([";" | xs]) do
    {:";", xs}
  end

  # terminal char
  def read(["," | xs]) do
    {:",", xs}
  end

  # when token is "(", parse to ")"
  def read([")" | xs]) do
    {:")", xs}
  end

  # sin( ... ->  [sin,...]
  def read([x, "(" | xs]) do
    {arg, buf} = read_arg(xs, [])
    {[String.to_atom(x) | arg], buf}
  end

  # 10! ->  [:!, 10]
  def read([x, "!" | xs]) do
    cond do  
      is_integer_str(x) -> {[:!,String.to_integer(x)], xs}
      is_float_str(x) -> {[:!,String.to_float(x)], xs}
      true -> {[:!,String.to_atom(x)], xs}
    end
  end

  # (x+y) ... -> [:+,:x,:y]
  def read(["(" | xs]) do
    {fmla, buf, _} = parse([], [], xs, [:")"])
    {fmla, buf}
  end

  def read([x | xs]) do
    cond do
      is_integer_str(x) -> {String.to_integer(x), xs}
      is_float_str(x) -> {String.to_float(x), xs}
      true -> {String.to_atom(x), xs}
    end
  end

  def read_arg(buf, args) do
    {fmla, buf1, term} = parse([], [], buf, [:",", :")"])

    cond do
      term == :")" -> {args ++ [fmla], buf1}
      true -> read_arg(buf1, args ++ [fmla])
    end
  end

  @doc """
  ## example
  iex>Read.tokenize("sin(x)+cos(x");)
  ["sin","(","x",")","+","cos","(","x",")",";"]
  """
  def tokenize(str) do
    str
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
    |> String.replace("{", " { ")
    |> String.replace("}", " } ")
    |> String.replace(",", " , ")
    |> String.replace(";", " ; ")
    |> String.replace("+", " + ")
    |> String.replace("-", " - ")
    |> String.replace("*", " * ")
    |> String.replace("/", " / ")
    |> String.replace("^", " ^ ")
    |> String.replace("!", " ! ")
    |> String.replace("\n", " ")
    |> String.split()
  end

  def is_integer_str(x) do
    cond do
      x == "" ->
        false

      # 123
      Enum.all?(x |> String.to_charlist(), fn y -> y >= 48 and y <= 57 end) ->
        true

      # +123
      # +
      String.length(x) >= 2 and
        x |> String.to_charlist() |> hd == 43 and
          Enum.all?(x |> String.to_charlist() |> tl, fn y -> y >= 48 and y <= 57 end) ->
        true

      # -123
      # -
      String.length(x) >= 2 and
        x |> String.to_charlist() |> hd == 45 and
          Enum.all?(x |> String.to_charlist() |> tl, fn y -> y >= 48 and y <= 57 end) ->
        true

      true ->
        false
    end
  end

  def is_float_str(x) do
    y = String.split(x, ".")
    z = String.split(x, "e")
    z1 = String.split(x, "E")

    cond do
      length(y) == 1 and length(z) == 1 -> false
      length(y) == 2 and is_integer_str(hd(y)) and is_integer_str(hd(tl(y))) -> true
      length(z) == 2 and is_float_str(hd(z)) and is_integer_str(hd(tl(z))) -> true
      length(z1) == 2 and is_float_str(hd(z1)) and is_integer_str(hd(tl(z1))) -> true
      true -> false
    end
  end
end
