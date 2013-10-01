defmodule KuraudoTest do
  use ExUnit.Case

  setup_all do
    Kuraudo.start
  end

  test "dummy test" do
  	assert(true)
  end
end