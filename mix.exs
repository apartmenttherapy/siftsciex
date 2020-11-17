defmodule Siftsciex.MixProject do
  use Mix.Project

  def project do
    [
      app: :siftsciex,
      name: "Siftsciex",
      description: description(),
      package: package(),
      version: "0.6.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      dialyzer: [plt_add_deps: :transitive, ignore_warnings: "dialyzer.ignore-warnings"],
      deps: deps(),
      source_url: "https://github.com/apartmenttherapy/siftsciex",
      docs: [extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test),      do: ["lib", "test/support"]
  defp elixirc_paths(_),          do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, ">= 0.0.0", only: [:dev, :test]},
      {:dialyxir, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:excoveralls, ">= 0.0.0", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:httpoison, ">= 0.0.0"},
      {:poison, ">= 0.0.0"}
    ]
  end

  defp description do
    "An Elixir Library for interacting with Sift Science's REST API"
  end

  defp package do
    [
      licenses: ["LGPLv3"],
      maintainers: ["Glen Holcomb"],
      links: %{"GitHub" => "https://github.com/apartmenttherapy/siftsciex"},
      source_url: "https://github.com/apartmenttherapy/siftsciex"
    ]
  end
end
