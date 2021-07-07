defmodule Siftsciex.Event.Error do
  @moduledoc """
  This module encapsulates event errors so it's easier to debug problems
  """
  defstruct [:type, :error_status, :error_message, :time]

  @type error_types :: :client_error | :server_error | :transport_error | :redirected

  @type t :: %__MODULE__{
          type: error_types(),
          error_status: integer() | nil,
          error_message: :atom | String.t() | nil,
          time: DateTime.t()
        }

  @doc """
  Build an error struct without parsing the response body
  """
  @spec build(error_types(), String.t()) :: t()
  def build(type, error_message) do
    %__MODULE__{
      type: type,
      error_message: error_message,
      time: DateTime.utc_now()
    }
  end

  @doc """
  Parses the error response from sift events API into a struct
  """
  @spec from_body(error_types(), String.t()) :: t()
  def from_body(type, body) when is_binary(body) do
    body
    |> Poison.decode()
    |> case do
      {:ok, document} ->
        %__MODULE__{
          type: type,
          error_status: document["status"] || nil,
          error_message: document["error_message"] || nil,
          time: safe_parse_time(document["time"])
        }

      {:error, reason} ->
        %__MODULE__{
          type: :client_error,
          error_status: nil,
          error_message: "Failed to parse body: #{inspect(reason)}"
        }
    end
  end

  defp safe_parse_time(time) do
    case DateTime.from_unix(time) do
      {:ok, converted} -> converted
      _error -> DateTime.utc_now()
    end
  end
end
