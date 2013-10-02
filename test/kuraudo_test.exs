defmodule KuraudoTest do
  use ExUnit.Case
  require Kuraudo.Test.Configuration

  setup_all do
    Kuraudo.start
    Kuraudo.Test.Configuration.load_test_configuration()
  end

  test "dummy test", env do
  	Kuraudo.Test.Configuration.unless_skipe(env, :dummy) do
  	  assert(true)
  	end
  end
end
