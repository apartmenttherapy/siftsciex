defmodule Siftsciex.Verification.Transport do
  @moduledoc false

  @type result :: {:ok, HTTPoison.Response.t}
                  | {:error, HTTPoison.Error.t}

  @doc false
  @spec post(map, String.t, [] | Keyword.t) :: result
  def post(payload, endpoint, []) do
    {:ok, json} = Poison.encode(payload)

    credentials = "#{Application.get_env(:siftsciex, :api_key)}:" |> Base.encode64()

    transporter().post("#{root_url()}/#{endpoint}", json, [{"Authorization", "Basic #{credentials}"}, {"Content-Type", "application/json"}])
  end

  defp transporter do
    Application.get_env(:siftsciex, :http_transport) || HTTPoison
  end

  defp root_url, do: Application.get_env(:siftsciex, :verification_url)
end
