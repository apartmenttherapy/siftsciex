defmodule Siftsciex.Event.Response do
  @moduledoc """
  Module for handling a Sift Science Event response
  """

  require Logger

  alias Siftsciex.Event.Payload
  alias Siftsciex.Event.Response.Error
  alias Siftsciex.Score.Response, as: ScoreResponse

  defstruct status: :empty, message: :empty, time: :empty, request: :empty, score_response: :empty
  @type t :: %__MODULE__{status: Payload.payload_int,
                         message: Payload.payload_string,
                         time: :empty | DateTime.t,
                         request: Payload.payload_string,
                         score_response: :empty | ScoreResponse.t}

  @doc """
  Processes the respose from Sift Science

  ## Parameters

    - `body`: The response body from the Event Request

  ## Examples

      iex> Response.process(%{"status" => 0, "error_message" => "OK", "time" => time, "request" => ""})
      %Response{status: 0, message: "OK", time: date_time, request: "", score_response: :empty}

  """
  @spec process(String.t) :: __MODULE__.t
  def process(body) when is_binary(body) do
    body
    |> Poison.decode()
    |> case do
         {:ok, response} ->
           process(response)
         {:error, reason} ->
           Logger.error("Failed to parse (#{Kernel.inspect(reason)}) Sift Science response: #{body}")
           %__MODULE__{}
       end
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
    |> process_score(Map.get(body, "score_response"))
  end

  defp process_score(record, nil), do: record
  defp process_score(record, score) do
    {:ok, json} = Poison.encode(score)

    struct(record, score_response: ScoreResponse.process(json))
  end

  @doc """
  Determines whether the given Response struct reflects an error.

  ## Parameters

    - `response`: The `t:Siftsciex.Event.Response.t/0` struct to check

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

  @doc """
  Returns the error type (`t:Siftsciex.Event.Response.Error.value/0`) of the response if the response indicates an error.

  ## Parameters

    - `response`: The respnonse object to check the error for.

  ## Examples

      iex> Response.error(%Response{status: 51})
      :invalid_api_key

  """
  @spec error(__MODULE__.t) :: Error.value
  def error(response) do
    Error.error(response)
  end
end
