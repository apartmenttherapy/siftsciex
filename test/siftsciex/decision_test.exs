defmodule Siftsciex.DecisionTest do
  use ExUnit.Case

  alias Siftsciex.Decision

  test "new/1 builds a valid decision" do
    miliseconds = 1_528_813_580_000
    {:ok, expected_time} = DateTime.from_unix(miliseconds, :millisecond)
    result = Decision.new(%{"entity" => %{"type" => "user", "id" => "8"}, "decision" => %{"id" => "steralize"}, "time" => miliseconds})

    assert %Decision{entity: {:user, "8"}, decision: "steralize", time: ^expected_time} = result
  end
end
