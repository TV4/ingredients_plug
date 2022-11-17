defmodule IngredientsPlugTest do
  use ExUnit.Case
  doctest IngredientsPlug

  test "greets the world" do
    assert IngredientsPlug.hello() == :world
  end
end
