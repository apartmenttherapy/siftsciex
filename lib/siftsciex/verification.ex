defmodule Siftsciex.Verification do
  @moduledoc """
  The Verification module is used for using the Sift Verification Product for sending 2FA Codes to your users

  For more information please read their Verification Integration Guide: https://docs.google.com/document/d/11RK_oss2Z7TjydnugYHlG5tK41GMpCyfbNbjzZAYSfM/edit

  """

  alias Siftsciex.Verification.{Response, Transport}
  alias Siftsciex.Verification.Payload.{Check, Send, Resend}

  @type error_map :: %{required(String.t) => String.t}
  @type result :: {:ok, Response.t}
                  | {:error, :transport_error, any}


  @doc """
  Checks whether a 2FA Code delivered to your user is valid or not

  ## Parameters

    - `data`: The data for the check request see `t:Siftsciex.Verification.Payload.Check/0` for details on the keys expected.

  ## Examples

      iex> Siftsciex.Verification.check(%{user_id: 18128799, verified_entity_id: "793325", verified_event: "$update_account", code: "490092"})
      {:ok,
        %Siftsciex.Verification.Response.Check{
          checked_at: ~U[2020-08-07 17:56:02.720Z],
          message: "Invalid Code",
          status: 50
        }}
  """
  @spec check(map, Keyword.t) :: result
  def check(data, opts \\ []) do
    data
    |> Check.new()
    |> post("check", opts)
  end

  @doc """
  Requests that a 2FA Code be resent to your user if they did not receive the first one

  ## Parameters

    - `data`: The data for the check request see `t:Siftsciex.Verification.Payload.Resend/0` for details on the keys expected.

  ## Examples

      iex(10)> Siftsciex.Verification.resend(%{user_id: "18128799", verified_entity_id: "1234567890123"})
      {:ok,
      %Siftsciex.Verification.Response.Send{
        brand_name: "",
        content_language: "",
        message: "OK",
        segment_id: "2130099a-a939-47eb-809f-f423ad37aed4",
        segment_name: "Untitled",
        sent_at: ~U[2020-08-07 17:56:02.720Z],
        site_country: "",
        status: 0
      }}
  """
  @spec resend(map, Keyword.t) :: result
  def resend(data, opts \\ []) do
    data
    |> Resend.new()
    |> post("resend", opts)
  end

  @doc """
  Requests that a 2FA Code be sent to your user

  ## Parameters

    - `data`: The data for the check request see `t:Siftsciex.Verification.Payload.Send/0` for details on the keys expected.

  ## Examples

      iex(11)> Siftsciex.Verification.send(%{user_id: 18128799, send_to: "fake.email@gmail.com", verification_type: "$email", event: %{verified_entity_id: "1234567890123", verified_event: "$update_account", session_id: "1234567890123"}})
      {:ok,
      %Siftsciex.Verification.Response.Send{
        brand_name: "",
        content_language: "",
        message: "OK",
        segment_id: "2130099a-a939-47eb-809f-f423ad37aed4",
        segment_name: "Untitled",
        sent_at: ~U[2020-08-07 17:56:02.720Z],
        site_country: "",
        status: 0
      }}
  """
  @spec send(map, Keyword.t) :: result
  def send(data, opts \\ []) do
    data
    |> Send.new()
    |> post("send", opts)
  end

  defp post(payload, endpoint, opts) do
    payload
    |> Transport.post(endpoint, opts)
    |> process_response(endpoint)
  end

  defp process_response(response, endpoint) do
    case response do
      {:ok, %{status_code: _status_code, body: body}} ->
        {:ok, Response.process(body, endpoint)}
      {:error, error} ->
        {:error, :transport_error, error.reason()}
    end
  end
end
