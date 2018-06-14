defmodule Siftsciex.Support.MockRequest do
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

  def known_time do
    1529011047
  end
end
