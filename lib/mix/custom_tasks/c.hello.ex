defmodule Mix.Tasks.C.Hello do
  @moduledoc """
  The module doc
  """

  use Mix.Task

  @shortdoc "Says hello"
  def run(_args) do
    IO.puts("I am saying hello")
    IO.inspect(File.cwd())

    # IO.inspect(File.)
  end

  
end