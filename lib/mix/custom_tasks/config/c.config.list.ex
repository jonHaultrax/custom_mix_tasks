defmodule Mix.Tasks.C.Config.List do
  @moduledoc false

  use Mix.Task
  alias CustomTasks.Tree

  @shortdoc "Show the given structure of the config storage"
  def run(levels) do
    tree = Tree.get_config_tree()
    list(tree, levels)

    Tree.get_leaf(tree, ["ancillary", "alcoa", "0.1.exs"])
    |> IO.inspect()
  end

  defp list(nil, level) do
    IO.puts("Cannot find a match for #{level}")
  end

  defp list(tree, []) do
    Tree.print_tree(tree)
  end

  defp list(tree, leaves) do
    tree
    |> Tree.get_leaf(leaves)
    |> Tree.print_tree()
  end



end
