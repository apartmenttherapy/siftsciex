defmodule SiftsciexTest do
  use ExUnit.Case
  doctest Siftsciex

  test "mark/1 prepends a `$` to the given atom and returns an atom" do
    assert :"$test" = Siftsciex.mark(:test)
  end

  test "mark/1 prepends a `$` to the given string and returns an atom" do
    assert :"$test" = Siftsciex.mark("test")
  end
end
