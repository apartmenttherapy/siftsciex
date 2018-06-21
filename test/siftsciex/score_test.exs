defmodule Siftsciex.ScoreTest do
  use ExUnit.Case

  alias Siftsciex.Score
  alias Siftsciex.Score.Response

  doctest Score, except: [score_for: 2]

  test "score_for/1 returns the score for a user" do
    assert {:ok, %Response{}} = Score.score_for("bob")
  end
end
