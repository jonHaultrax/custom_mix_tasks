defmodule Mix.Tasks.Man.Hello do
  @moduledoc """
  The module doc
  """

  use Mix.Task

  @shortdoc "Says hello"
  def run(_args) do
    IO.puts("I am saying hello")
  end
end