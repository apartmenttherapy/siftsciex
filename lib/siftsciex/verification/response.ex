defmodule Siftsciex.Verification.Response do
  @moduledoc """
  Module for handling a Sift Science Verification response
  """

  require Logger

  alias Siftsciex.Verification.Response.Check, as: CheckResponse
  alias Siftsciex.Verification.Response.Send, as: SendResponse
  
  @type t :: CheckResponse.t() | SendResponse.t()

  @doc """
  Processes the respose from Sift Science Verification requests

  ## Parameters

    - `body`: The response body from the Verification Request

  ## Examples

      iex(1)> Siftsciex.Verification.Response.process("{\\"status\\":50,\\"error_message\\":\\"Invalid Code\\",\\"checked_at\\":1596824708835}", "check")
      %Siftsciex.Verification.Response.Check{
        checked_at: ~U[2020-08-07 18:25:08.835Z],
        message: "Invalid Code",
        status: 50
      }
  """
  @spec process(String.t, String.t) :: __MODULE__.t
  def process(response_body, endpoint) when is_binary(response_body) do
    response_body
    |> Poison.decode()
    |> case do
         {:ok, body} ->
           process(body, String.to_atom(endpoint))
         {:error, reason} ->
           Logger.error("Failed to parse (#{Kernel.inspect(reason)}) Sift Science response: #{response_body}")
           %CheckResponse{}
       end
  end
  def process(body, :check) do
    checked_at = if body["checked_at"], do: epoch_to_datetime(body["checked_at"]), else: nil

    %{
      status: body["status"],
      message: body["error_message"],
      checked_at: checked_at
    }
    |> CheckResponse.new()
  end

  def process(body, :send), do: process_send_response(body)
  def process(body, :resend), do: process_send_response(body)

  defp process_send_response(body) do
    sent_at = if body["sent_at"], do: epoch_to_datetime(body["sent_at"]), else: nil

    %{
      status: body["status"],
      message: body["error_message"],
      sent_at: sent_at,
      segment_id: body["segment_id"],
      segment_name: body["segment_name"],
      brand_name: body["brand_name"],
      site_country: body["site_country"],
      content_language: body["content_language"]
    }
    |> SendResponse.new()
  end

  defp epoch_to_datetime(epoch) do
    {:ok, datetime} = DateTime.from_unix(epoch, :millisecond)
    datetime
  end
end
