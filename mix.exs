defmodule IngredientsPlug.MixProject do
  use Mix.Project

  def project do
    [
      app: :ingredients_plug,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.14"},
      {:jason, "~> 1.4"},
      {:httpoison, "~> 1.8"},
      {:timex, "~> 3.7"},
      {:hammox, "~> 0.7.0", only: :test}
    ]
  end
end
