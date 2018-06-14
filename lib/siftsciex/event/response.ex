defmodule Siftsciex.Event.Response do
  @moduledoc """
  Module for handling a Sift Science Event response
  """

  defstruct status: :empty, message: :empty, time: :empty, request: :empty
  @type t :: %__MODULE__{status: Payload.payload_int,
                         message: Payload.payload_string,
                         time: :empty | DateTime.t,
                         request: Payload.payload_string}

  @doc """
  Processes the respose from Sift Science

  ## Parameters

    - `body`: The response body from the Event Request

  ## Examples

      iex> Response.process(%{"status" => 0, "error_message" => "OK", "time" => time, "request" => ""})
      %Response{status: 0, message: "OK", time: date_time, request: ""}

  """
  @spec process(String.t) :: __MODULE__.t
  def process(body) when is_binary(body) do
    {:ok, response} = Poison.decode(body)

    process(response)
  end
  def process(body) do
    {:ok, time} = DateTime.from_unix(body["time"])

    __MODULE__
    |> struct([
         status: body["status"],
         message: body["error_message"],
         time: time,
         request: body["request"]
       ])
  end

  @doc """
  Determines whether the given Response struct reflects an error.

  ## Parameters

    - `response`: The `__MODULE__.t` struct to check

  ## Examples

      iex> Response.error?(%Response{status: 51})
      true

      iex> Response.error?(%Response{status: 0})
      false

  """
  @spec error?(__MODULE__.t) :: boolean
  def error?(response) do
    case response.status() do
      0 -> false
      _ -> true
    end
  end
end
