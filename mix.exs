defmodule UeberauthLinkedIn.MixProject do
  use Mix.Project

  @source_url "https://github.com/utf26/ueberauth_linkedin"

  def project do
    [
      app: :ueberauth_linkedin,
      version: "0.10.8",
      elixir: "~> 1.15",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      name: "UeberauthLinkedIn",
      description: description(),
      package: package(),
      source_url: @source_url,
      homepage_url: @source_url,
      deps: deps(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :oauth2, :ueberauth]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ueberauth, "~> 0.10"},
      {:oauth2, "~> 2.0"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "ueberauth_linkedin_modern",
      maintainers: ["Babar Saleh Hayat"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", "CONTRIBUTING.md", "README.md"],
      main: "readme",
      source_url: @source_url,
      homepage_url: @source_url,
      formatters: ["html"]
    ]
  end

  defp description do
    "An Ueberauth strategy for LinkedIn V2 authentication"
  end
end
