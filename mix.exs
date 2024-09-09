defmodule VintageNetSocketCAN.MixProject do
  use Mix.Project

  @version "0.1.0"
  @github "https://github.com/protolux-electronics/vintage_net_socket_can"

  def project do
    [
      app: :vintage_net_socket_can,
      version: @version,
      elixir: "~> 1.11",
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
      {:vintage_net, "~> 0.9.1 or ~> 0.10.0 or ~> 0.11.0 or ~> 0.12.0 or ~> 0.13.0"},
      {:credo, "~> 1.2", only: :test, runtime: false},
      {:dialyxir, "~> 1.4.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22", only: :docs, runtime: false}
    ]
  end
end
