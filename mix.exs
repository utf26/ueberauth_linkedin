defmodule UeberauthLinkedIn.MixProject do
  use Mix.Project

  def project do
    [
      app: :ueberauth_linkedin,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "UeberauthLinkedIn",
      description: "LinkedIn v2 strategy for Ueberauth.",
      package: package(),
      source_url: "https://github.com/utf26/ueberauth_linkedin"
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
      {:ueberauth, "~> 0.10"},
      {:oauth2, "~> 2.0"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "ueberauth_linkedin_modern",
      maintainers: ["Babar Saleh Hayat"],
      licenses: ["MIT", "Apache-2.0"],
      links: %{"GitHub" => "https://github.com/utf26/ueberauth_linkedin"}
    ]
  end
end
