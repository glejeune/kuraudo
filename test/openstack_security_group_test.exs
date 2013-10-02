defmodule KuraudoOpenStackSecurityGroupTest do
  use ExUnit.Case
  require Kuraudo.Test.Configuration

  setup_all do
    Kuraudo.start
    Kuraudo.Test.Configuration.load_test_configuration()
  end

  test "security group", env do
    Kuraudo.Test.Configuration.unless_skipe(env, :openstack) do
      driver = Kuraudo.OpenStack.Driver.new(Dict.get(env, :openstack))
      driver = Kuraudo.Provider.connect(driver)

      initial_sg_list = Kuraudo.SecurityGroups.all(driver)
      assert(initial_sg_list)

      new_sg = Kuraudo.SecurityGroups.create(driver, "Security_Group_Test")
      assert(new_sg.name == new_sg.description)
      assert(length(new_sg.rules) == 0)

      sg_by_name = Kuraudo.SecurityGroups.search_by_name(driver, new_sg.name)
      assert(new_sg == sg_by_name)
      sg_by_id = Kuraudo.SecurityGroups.search_by_id(driver, new_sg.id)
      assert(new_sg == sg_by_id)

      sg_add_rule = Kuraudo.SecurityGroups.add_rule(driver, new_sg, "tcp", 8080, 8080, "0.0.0.0/0")
      assert(length(sg_add_rule.rules) == 1)
      assert(Enum.at(sg_add_rule.rules, 0).protocol == "tcp")
      assert(Enum.at(sg_add_rule.rules, 0).from_port == 8080)

      sg_delete_rule = Kuraudo.SecurityGroups.delete_rule(driver, Enum.at(sg_add_rule.rules, 0))
      assert(length(sg_delete_rule.rules) == 0)

      assert(Kuraudo.SecurityGroups.delete(driver, sg_delete_rule))
      final_sg_list = Kuraudo.SecurityGroups.all(driver)
      assert(length(initial_sg_list) == length(final_sg_list))
    end
  end
end
