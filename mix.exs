defmodule Manager.MixProject do
  use Mix.Project
  @version "0.1.0"
  @default_archive "archive/man.ez"
  @versioned_archive "archive/man-#{@version}.ez"

  def project do
    [
      app: :manager,
      version: @version,
      elixir: "~> 1.9",
      description: "Helper functions for me",
      start_permanent: Mix.env() == :prod,
      aliases: aliases()
    ]
  end

  def aliases do
    [
      "man.build": &build_release/1
    ]
  end

  defp build_release(_) do
    File.mkdir_p("archive")

    Mix.Tasks.Compile.run([])
    Mix.Tasks.Archive.Build.run(["--output=#{@default_archive}"])
    Mix.Tasks.Archive.Build.run(["--output=#{@versioned_archive}"])
  end
end
