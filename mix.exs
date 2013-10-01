defmodule Kuraudo.Mixfile do
  use Mix.Project

  def project do
    [ app: :kuraudo,
      version: "0.0.1",
      elixir: "~> 0.10.3-dev",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
    #{:erlcloud,[github: "gleber/erlcloud"]},
      {:mimetypes, [github: "spawngrid/mimetypes"]},
      {:ex_doc, [github: "elixir-lang/ex_doc"]},
      {:jsonex, [github: "marcelog/jsonex"]},
      {:httpotion, [github: "myfreeweb/httpotion"]},
      {:shakkei, [github: "glejeune/shakkei"]},
      {:lager, [github: "basho/lager"]}
    ]
  end
end
