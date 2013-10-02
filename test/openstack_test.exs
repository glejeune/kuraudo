defmodule KuraudoOpenStackTest do
  use ExUnit.Case
  require Kuraudo.Test.Configuration

  setup_all do
    Kuraudo.start
    Kuraudo.Test.Configuration.load_test_configuration()
  end

  test "connect then inspect", env do
    Kuraudo.Test.Configuration.unless_skipe(env, :openstack) do
      driver = Kuraudo.OpenStack.Driver.new(Dict.get(env, :openstack))
      driver = Kuraudo.Provider.connect(driver)

      assert(inspect(driver) =~ %r/OpenStack @ .*/)
    end
  end
end
