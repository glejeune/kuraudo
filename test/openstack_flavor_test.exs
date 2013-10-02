defmodule KuraudoOpenStackFlavorTest do
  use ExUnit.Case
  require Kuraudo.Test.Configuration

  setup_all do
    Kuraudo.start
    Kuraudo.Test.Configuration.load_test_configuration()
  end

  test "get flavors", env do
    Kuraudo.Test.Configuration.unless_skipe(env, :openstack) do
      driver = Kuraudo.OpenStack.Driver.new(Dict.get(env, :openstack))
      driver = Kuraudo.Provider.connect(driver)

      flavor_list = Kuraudo.Flavors.all(driver)
      assert(length(flavor_list) > 0) 

      flavor = Kuraudo.Flavors.search_by_id(driver, Enum.first(flavor_list).id)
      assert(flavor == Enum.first(flavor_list))
    end
  end
end
