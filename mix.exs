defmodule Htmd.MixProject do
  use Mix.Project
  @version "0.2.0"
  @source_url "https://github.com/kasvith/htmd"

  def project do
    [
      app: :htmd,
      name: "Htmd",
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      source_url: @source_url
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
      {:rustler, "~> 0.36.2", optional: true},
      {:rustler_precompiled, "~> 0.8"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true}
    ]
  end

  defp description do
    "HTML to Markdown converter written in Rust with Elixir bindings"
  end

  defp package do
    [
      name: "htmd",
      maintainers: ["Kasun Vithanage"],
      description: "A fast HTML to Markdown converter for Elixir, powered by Rust.",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/kasvith/htmd"},
      files: ~w(lib native .formatter.exs README* LICENSE* mix.exs checksum-*.exs)
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      extras: [{:"README.md", [title: "README"]}]
    ]
  end
end
