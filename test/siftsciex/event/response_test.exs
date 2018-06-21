defmodule Siftsciex.Event.ResponseTest do
  use ExUnit.Case

  alias Siftsciex.Event.Response
  alias Siftsciex.Score.Response, as: ScoreResponse
  alias Siftsciex.Score.Response.{Reason, Score}

  doctest Response

  test "process/1 handles the `score_response` if present" do
    expected = %Response{status: 0, message: "OK", request: "stuff", time: date_time(), score_response: %ScoreResponse{status: 0, error_message: "OK", user_id: "bob", latest_labels: :empty, scores: [%Score{type: :payment_abuse, score: 0.383, reasons: [%Reason{name: "Fraudster"}]}]}}

    assert ^expected = Response.process(with_response())
  end

  def time, do: 1_528_999_522
  def date_time do
    {:ok, value} = DateTime.from_unix(1_528_999_522)

    value
  end

  def with_response do
    """
    {
      "status": 0,
      "error_message": "OK",
      "request": "stuff",
      "time": #{time()},
      "score_response": #{score_response()}
    }
    """
  end

  def score_response do
    """
    {
      "status": 0,
      "error_message": "OK",
      "user_id": "bob",
      "scores": {
        "payment_abuse": {
          "score": 0.383,
          "reasons": [
            {
              "name": "Fraudster"
            }
          ]
        }
      }
    }
    """
  end
end
