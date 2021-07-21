defmodule Siftsciex.Event.Transport do
  @moduledoc false

  @type result :: {:ok, HTTPoison.Response.t}
                  | {:error, HTTPoison.Error.t}

  @doc false
  @spec post(map, [] | Keyword.t) :: result
  def post(payload, []) do
    {:ok, json} = Poison.encode(payload)

    transporter().post(url(), json)
  end

  def post(payload, [scores: scores]) do
    {:ok, json} = Poison.encode(payload)
    query = "?return_score=true&abuse_types=#{Enum.join(scores, ",")}"

    transporter().post(url() <> query, json)
  end

  def post(payload, [return_workflow_status: true]) do
    {:ok, json} = Poison.encode(payload)
    query = "?return_workflow_status=true"

    transporter().post(url() <> query, json)
  end

  defp transporter do
    Application.get_env(:siftsciex, :http_transport) || HTTPoison
  end

  defp url, do: Application.get_env(:siftsciex, :events_url)
end
