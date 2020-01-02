defmodule Mix.Tasks.Minima do
  use Mix.Task

  def run(_) do
    Minima.repl()
  end
end
