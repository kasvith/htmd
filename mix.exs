defmodule Htmd.MixProject do
  use Mix.Project

  def project do
    [
      app: :htmd,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/kasvith/htmd"
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
      {:rustler, "~> 0.36.2", runtime: false}
    ]
  end

  defp description do
    "HTML to Markdown converter written in Rust with Elixir bindings"
  end

  defp package do
    [
      name: "htmd",
      maintainers: ["Kasun Vithanage"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/kasvith/htmd"}
    ]
  end
end
