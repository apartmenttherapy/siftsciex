defmodule Siftsciex.Support.MockRequest do
  @moduledoc false

  def post(_, %{"$user_id": "transport_error"} = _data) do
    {:error, %{reason: "Timeout"}}
  end
  def post(_, %{"$user_id": "server_error"} = _data) do
    {:ok, %{status_code: 500}}
  end
  def post(_, %{"$user_id": "client_error"} = _data) do
    {:ok, %{status_code: 404}}
  end
  def post(_, data) do
    response = %{
      status: 0,
      error_message: "OK",
      time: known_time(),
      request: data
    }
    {:ok, response} = Poison.encode(response)

    {:ok, %{status_code: 200, body: response}}
  end

  def post("/send", data, _) do
    response = %{
      status: 0,
      error_message: "OK",
      brand_name: "",
      content_language: "",
      segment_id: "2130099a-a939-47eb-809f-f423ad37aed4",
      segment_name: "Untitled",
      sent_at: 1596822962720,
      site_country: "",
      request: data
    }
    {:ok, response} = Poison.encode(response)

    {:ok, %{status_code: 200, body: response}}
  end

  def post("/resend", data, _) do
    response = %{
      status: 0,
      error_message: "OK",
      brand_name: "",
      content_language: "",
      segment_id: "2130099a-a939-47eb-809f-f423ad37aed4",
      segment_name: "Untitled",
      sent_at: 1596822962720,
      site_country: "",
      request: data
    }
    {:ok, response} = Poison.encode(response)

    {:ok, %{status_code: 200, body: response}}
  end

  def post("/check", data, _) do
    response = %{
      status: 50,
      error_message: "Invalid Code",
      checked_at: 1596822962720,
      request: data
    }
    {:ok, response} = Poison.encode(response)

    {:ok, %{status_code: 200, body: response}}
  end

  def get(_url) do
    {:ok, %{status_code: 200, body: score_response()}}
  end

  def get(_url, _headers) do
    {:ok, %{status_code: 200, body: decision_response()}}
  end

  defp score_response do
    """
    {
      "status": 0,
      "error_message": "OK",
      "user_id": "bob",
      "scores": {
        "payment_abuse": {
          "score": 0.4,
          "reasons": [
            {
              "name": "Dirty"
            }
          ]
        }
      }
    }
    """
  end

  defp decision_response do
    """
    {
      "decisions": {
        "payment_abuse": {
          "decision": {
            "id": "auto_block_payment_abuse"
          },
          "time": 1613777136497,
          "webhook_succeeded": false
        }
      }
    }
    """
  end

  def known_time do
    1_529_011_047
  end
end
