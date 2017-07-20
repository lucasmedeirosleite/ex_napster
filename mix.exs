defmodule ExNapster.Mixfile do
  use Mix.Project

  @name "ExNapster"
  @author "Lucas Medeiros Leite"
  @version "0.1.0"
  @source_url "https://github.com/lucasmedeirosleite/ex_napster"
  @description "An Elixir wrapper for the Napster Web API."

  def project do
    [app: :ex_napster,
     elixir: ">= 1.3.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     test_coverage: [tool: ExCoveralls, test_task: "espec"],
     preferred_cli_env: ["espec": :test,
                         "coveralls": :test,
                         "coveralls.detail": :test,
                         "coveralls.post": :test,
                         "coveralls.html": :test],

     name: @name,
     version: @version,
     description: @description,
     source_url: @source_url,
     homepage_url: @source_url,
     docs: [extras: ["README.md"], main: @name]
    ]
  end

  def application do
    [extra_applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.12.0"},
      {:ex_doc, "~> 0.16.2", only: :dev, runtime: false},
      {:espec, "~> 1.4", only: :test},
      {:credo, "~> 0.8.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.7.1", only: :test},
      {:inch_ex, "~> 0.5.6", only: :docs},
    ]
  end

  defp package do
    %{
      maintainers: [@author],
      licenses: ["MIT"],
      files: ["lib", "src/*.xrl", "mix.exs", "README.md", "LICENSE"],
      links: %{
        "GitHub" => "https://github.com/lucasmedeirosleite/ex_napster",
        "Docs"   => "https://hexdocs.pm/ex_napster"
      }
    }
  end
end
