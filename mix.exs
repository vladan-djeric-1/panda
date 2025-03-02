defmodule Panda.MixProject do
  use Mix.Project

  def project do
    [
      app: :panda,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Panda.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2.2"},
      {:plug_cowboy, "~> 2.0"},
      {:cachex, "~> 3.3"},
      {:mox, "~> 0.5.2", only: [:test], runtime: false}
    ]
  end
end
