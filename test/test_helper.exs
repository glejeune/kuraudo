ExUnit.start

defmodule Kuraudo.Test.Configuration do
  def load_test_configuration() do
  	conf_file = Path.join(__DIR__, "_test_conf.exs")
  	unless File.exists?(conf_file) do
  	  IO.puts "----------------------------------------------------------"
  	  IO.puts "    _       No configuration file found."
      IO.puts "   / \\"
      IO.puts "  / | \\    To run test, you need to create a file named"
      IO.puts " /  o  \\   `_test_conf.exs` in the `test` directory."
      IO.puts "/_______\\  Please, read the documentation if you need more"
      IO.puts "           informations"
  	  IO.puts "----------------------------------------------------------"
  	  exit(:normal)
  	else
      {konfig , _} = Code.eval_string("konfig = " <> File.read!(conf_file))
      {:ok, konfig}
  	end
  end

  defmacro unless_skipe(env, scope, options) do
    quote do: unless(
      Enum.any?(Dict.get(unquote(env), :skip, []), fn(e) -> e == unquote(scope) end)
      || !Dict.get(unquote(env), unquote(scope), false),
      do: unquote(options),
      else: IO.puts "\nSkip scope test #{unquote(scope)}."
    )
  end
end

