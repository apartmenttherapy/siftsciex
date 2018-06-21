defmodule Siftsciex.Support.MockRequest do
  @moduledoc false

  def post(_, %{"$user_id": "transport_error"} = data) do
    {:error, %{reason: "Timeout"}}
  end
  def post(_, %{"$user_id": "server_error"} = data) do
    {:ok, %{status_code: 500}}
  end
  def post(_, %{"$user_id": "client_error"} = data) do
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

  def get(url) do
    {:ok, %{status_code: 200, body: score_response}}
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

  def known_time do
    1_529_011_047
  end
end
