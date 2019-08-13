defmodule CustomTasks.Tree do
  
  def get_config_tree(path \\ "./config/**" ) do
    path
    |> Path.wildcard()
    |> Enum.map(&String.split(&1, "/"))
    |> Enum.map(&remove_head/1)
    |> Enum.reduce(%{}, fn leaves, tree ->
      add_leaves(tree, leaves)
    end)
  end

  def get_leaf(tree, leaf) when is_binary(leaf), do: get_leaf(tree, [leaf])

  def get_leaf(tree, leaves) do
    n_leaves = length(leaves)
    cond do
      n_leaves > 3 -> nil
      n_leaves < 3 -> get_in(tree, leaves)
      n_leaves == 3 ->
        [repo, site, version] = leaves
        case get_in(tree, [repo, site]) do
          nil -> nil
          list -> Enum.find(list, &(&1 == version))
        end 
    end
  end

  # ------------------ print tree ---------------
  def print_tree(nil) do
    IO.puts("No tree found")
  end

  def print_tree(string) when is_binary(string) do
    print(string)
  end

  def print_tree(list) when is_list(list) do
    Enum.each(list, &print/1)
  end
  def print_tree(tree) do
    Enum.each(tree, &print_leaf(&1, 0))
  end

  # ------------- print leaves ----------------

  defp print_leaf({key, empty_map}, indent) when empty_map == %{} do
    print(key, indent)
  end

  defp print_leaf({key, map}, indent) when is_map(map) do
    print(key, indent)
    Enum.each(map, &print_leaf(&1, indent + 1))
  end

  defp print_leaf({key, []}, indent) do
    print(key, indent)
  end

  defp print_leaf({key, list}, indent) when is_list(list) do
    print(key, indent)
    Enum.each(list, &print(&1, indent + 1))
  end

  defp print(msg, indent \\ 0), do: "#{padding(indent)}- #{msg}" |> IO.puts()

  defp padding(0), do: ""
  defp padding(n), do: String.duplicate("   ", n)

  # ------------- creating tree ----------------
  defp remove_head([]), do: nil
  defp remove_head([_head | tail]), do: tail

  defp add_leaves(tree, [repo]) do
    Map.put_new(tree, repo, %{})
  end

  defp add_leaves(tree, [repo, site]) do
    tree = add_leaves(tree, [repo])

    case get_in(tree, [repo, site]) do
      nil -> put_in(tree, [repo, site], [])
      _ -> tree
    end
  end

  defp add_leaves(tree, [repo, site, version]) do
    tree = add_leaves(tree, [repo, site])

    case get_in(tree, [repo, site]) do
      nil -> put_in(tree, [repo, site], [version])
      versions -> put_in(tree, [repo, site], [version | versions])
    end
  end
end