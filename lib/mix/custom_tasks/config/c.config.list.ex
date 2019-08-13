defmodule Mix.Tasks.C.Config.List do
  @moduledoc """

  """

  use Mix.Task

  @shortdoc ""
  def run(_args) do
    tree = get_config_tree()
    |> IO.inspect()

    get_leaf(tree, "a")
    |> IO.inspect()

    get_leaf(tree, "b")
    |> IO.inspect()

    get_leaf(tree, ["a", "sitey"])
    |> IO.inspect()
  end

  def get_config_tree() do
    "./config/**"
    |> Path.wildcard()
    |> Enum.map(&String.split(&1, "/"))
    |> Enum.map(&remove_head/1)
    |> Enum.reduce(%{}, fn leaves, tree ->
      add_leaves(tree, leaves)
    end)
  end

  def get_leaf(tree, leaf) when is_binary(leaf), do: get_leaf(tree, [leaf])
  def get_leaf(tree, leaves) do
    get_in(tree, leaves)
  end

  defp remove_head([]), do: nil
  defp remove_head([head | tail]), do: tail
 
  defp add_leaves(tree, [repo]) do
    Map.put_new(tree, repo, %{})
  end

  defp add_leaves(tree, [repo, site]) do
    tree = add_leaves(tree, [repo])
    
    case Map.get(tree, site, nil) do
      nil -> put_in(tree, [repo, site], [])
      _ -> tree
    end
  end

  defp add_leaves(tree, [repo, site, version]) do
    tree = add_leaves(tree, [repo, site])

    case Map.get(tree, site, nil) do
      nil -> put_in(tree, [repo, site], [version])
      versions -> put_in(tree, [repo, site], [version | versions])
    end
  end
end
