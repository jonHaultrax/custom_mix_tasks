defmodule CustomTasks.MixProject do
  use Mix.Project
  @version "0.1.0"
  @archive "c"
  @archive_dir "#{@archive}.ez"

  def project do
    [
      app: :custom_tasks,
      version: @version,
      elixir: "~> 1.9",
      description: "Helper functions for me",
      start_permanent: Mix.env() == :prod,
      aliases: aliases()
    ]
  end

  def aliases do
    [
      "c.install": &install/1,
      "c.uninstall": &uninstall/1
    ]
  end

  defp compile() do
    Mix.Tasks.Compile.run([])
  end

  defp install(_) do
    File.mkdir_p("archive")

    compile()
    Mix.Tasks.Archive.Build.run(["--output=#{@archive_dir}"])

    Mix.Tasks.Archive.Install.run([@archive_dir, "--force"])
    |> case do
      true -> IO.puts("Archive '#{@archive}' installed")
      false -> IO.puts("Archive '#{@archive}' not installed")
    end
  end

  defp uninstall(_) do
    compile()

    get_archives()
    |> Enum.member?("c")
    |> case do
      true ->
        Mix.Tasks.Archive.Uninstall.run([@archive, "--force"])
        IO.puts("Archive '#{@archive}' uninstalled")

      false ->
        IO.puts("Archive '#{@archive}' not present")
    end
  end

  defp get_archives() do
    Mix.Local.path_for(:archive)
    |> Path.join("*")
    |> Path.wildcard()
    |> Enum.map(&Path.basename/1)
  end
end
