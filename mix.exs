defmodule Twixir.Mixfile do
  use Mix.Project

  def project do
    [app: :twixir,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:exirc]]
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:exirc, "~> 1.0.1"}]
  end
end
