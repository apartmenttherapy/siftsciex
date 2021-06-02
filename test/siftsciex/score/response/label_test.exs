defmodule Siftsciex.Score.Response.LabelTest do
  use ExUnit.Case

  alias Siftsciex.Score.Response.Label

  doctest Label, except: [new: 1]

  test "new/1 returns a label map" do
    expected = %{payment_abuse: %Label{is_bad: true, time: expected_time(), description: "Fake card"}}

    assert ^expected = Label.new(%{payment_abuse: %{is_bad: true, time: 1_529_011_047, description: "Fake card"}})
  end

  def expected_time do
    {:ok, time} = DateTime.from_unix(1_529_011_047)

    time
  end
end
