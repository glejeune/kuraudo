defmodule KuraudoOpenStackImageTest do
  use ExUnit.Case
  require Kuraudo.Test.Configuration

  setup_all do
    Kuraudo.start
    Kuraudo.Test.Configuration.load_test_configuration()
  end

  test "Get images list", env do
    Kuraudo.Test.Configuration.unless_skipe(env, :openstack) do
      driver = Kuraudo.OpenStack.Driver.new(Dict.get(env, :openstack))
      driver = Kuraudo.Provider.connect(driver)

      list = Kuraudo.Images.all(driver)
      assert(length(list) > 0) 

      img = Kuraudo.Images.search_by_id(driver, Enum.first(list).id)
      assert(img == Enum.first(list))
    end
  end

  test "create and delete image", env do
    Kuraudo.Test.Configuration.unless_skipe(env, :openstack) do
      driver = Kuraudo.OpenStack.Driver.new(Dict.get(env, :openstack))
      driver = Kuraudo.Provider.connect(driver)

      image = Kuraudo.Images.create(
        driver, 
        "Cirros 0.3.0 by Kuraudo",
        Path.join(__DIR__, "cirros-0.3.0-x86_64-disk.img"),
        :qcow2,
        tags: ["x86_64", "Cirros", "0.3.0", "Kuraudo", "tests"]
      )
      assert(image)

      assert(Kuraudo.Images.delete(driver, image))
    end
  end
end
