defmodule Siftsciex.DecisionTest do
  use ExUnit.Case

  alias Siftsciex.Decision

  doctest Decision

  test "decisions_for/3 raises an error if a session entity is requested with no user_id" do
    assert_raise RuntimeError, "Missing user_id for session or content URL", fn ->
      Decision.decisions_for("1234", "session")
    end
  end

  test "decisions_for/3 raises an error if a content entity is requested with no user_id" do
    assert_raise RuntimeError, "Missing user_id for session or content URL", fn ->
      Decision.decisions_for("1234", "content")
    end
  end

  test "new/1 builds a valid decision" do
    miliseconds = 1_528_813_580_000
    {:ok, expected_time} = DateTime.from_unix(miliseconds, :millisecond)
    result = Decision.new(%{"entity" => %{"type" => "user", "id" => "8"}, "decision" => %{"id" => "steralize"}, "time" => miliseconds})

    assert %Decision{entity: {:user, "8"}, decision: "steralize", time: ^expected_time} = result
  end
end
