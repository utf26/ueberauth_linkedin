defmodule UeberauthLinkedIn.MixProject do
  use Mix.Project

  @url "https://github.com/utf26/ueberauth_linkedin"

  def project do
    [
      app: :ueberauth_linkedin,
      version: "1.1.0",
      elixir: "~> 1.15",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      name: "UeberauthLinkedIn",
      description: description(),
      package: package(),
      source_url: @url,
      homepage_url: @url,
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
      links: %{"GitHub" => @url}
    ]
  end

  defp docs do
    [extras: docs_extras(), main: "readme"]
  end

  defp docs_extras do
    ["README.md"]
  end

  defp description do
    "An Ueberauth strategy for LinkedIn V2 authentication"
  end
end
