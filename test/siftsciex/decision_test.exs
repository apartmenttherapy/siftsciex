defmodule Siftsciex.DecisionTest do
  use ExUnit.Case

  alias Siftsciex.Decision

  test "new/1 builds a valid decision" do
    seconds = 1528813580
    {:ok, expected_time} = DateTime.from_unix(seconds)
    result = Decision.new(%{"entity" => %{"type" => "user", "id" => "8"}, "decision" => %{"id" => "steralize"}, "time" => seconds})

    assert %Decision{entity: {:user, "8"}, decision: "steralize", time: ^expected_time} = result
  end
end
