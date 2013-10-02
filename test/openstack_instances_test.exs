defmodule KuraudoOpenStackInstanceTest do
  use ExUnit.Case
  require Kuraudo.Test.Configuration

  setup_all do
    Kuraudo.start
    Kuraudo.Test.Configuration.load_test_configuration()
  end

  test "get instances list", env do
    Kuraudo.Test.Configuration.unless_skipe(env, :openstack) do
      driver = Kuraudo.OpenStack.Driver.new(Dict.get(env, :openstack))
      driver = Kuraudo.Provider.connect(driver)

      response = Kuraudo.Instances.all(driver)
      assert(response) 
    end
  end

  # test "create instance", env do
  #   Kuraudo.Test.Configuration.unless_skipe(env, :openstack) do
  #     driver = Kuraudo.OpenStack.Driver.new(Dict.get(env, :openstack))
  #     driver = Kuraudo.Provider.connect(driver)

  #     image = Kuraudo.Images.search_by_id(driver, "9165dafa-9732-4256-a14d-43012510c6e1")
  #     flavor = Kuraudo.Flavors.search_by_id(driver, "1")
  #     server = Kuraudo.Instances.create(driver, "create_ex", flavor, image)
  #     server = Kuraudo.Instances.wait(driver, server)
  #     assert(server.status == :active)

  #     assert(Kuraudo.Instances.pause(driver, server))
  #     server = Kuraudo.Instances.wait(driver, server, :paused)
  #     assert(server.status == :paused)

  #     assert(Kuraudo.Instances.unpause(driver, server))
  #     server = Kuraudo.Instances.wait(driver, server, :active)
  #     assert(server.status == :active)

  #     assert(Kuraudo.Instances.suspend(driver, server))
  #     server = Kuraudo.Instances.wait(driver, server, :suspended)
  #     assert(server.status == :suspended)

  #     assert(Kuraudo.Instances.resume(driver, server))
  #     server = Kuraudo.Instances.wait(driver, server, :active)
  #     assert(server.status == :active)

  #     assert(Kuraudo.Instances.stop(driver, server))
  #     server = Kuraudo.Instances.wait(driver, server, :shutoff)
  #     assert(server.status == :shutoff)

  #     assert(Kuraudo.Instances.start(driver, server))
  #     server = Kuraudo.Instances.wait(driver, server, :active)
  #     assert(server.status == :active)

  #     assert(Kuraudo.Instances.delete(driver, server))
  #   end
  # end
end
