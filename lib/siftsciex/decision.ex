defmodule Siftsciex.Decision do
  @moduledoc """
  The Decision module defines an internal structure for the data Sift Science sends in their Webhook payload.

  This data indicates that an action should be taken on the given "entity".  Webhooks are triggered either by conditions in one of your Workflows or manual actions taken in Sift Science by humans in your organization (reviewer actions).
  """

  require Logger

  alias Siftsciex.Decision.Response

  @transport Application.get_env(:siftsciex, :http_transport) || HTTPoison

  defstruct [:entity, :decision, :time]
  @type t :: %__MODULE__{entity: entity, decision: String.t, time: DateTime.t}
  @type entity :: {entity_type, String.t}

  @type entity_type :: :user | :order | :session | :content
  @entity_type %{"user" => :user,
                 "order" => :order,
                 "session" => :session,
                 "content" => :content}
  @type result :: {:ok, Response.t}
                  | {:error,  :redirected, String.t}
                  | {:error, :client_error, integer}
                  | {:error, :server_error, integer}
                  | {:error, :transport_error, any}

  @doc """
  Creates a new `t:Siftsciex.Decision.t/0` struct from the given map (parsed JSON)

  ## Parameters

    - `body`: A map representing the parsed JSON for a Sift Science Decision

  ## Examples

      iex> Decision.new(%{"entity" => %{"type" => "user", "id" => "8"}, "decision" => %{"id" => "steralize"}, "time" => 1528813580})
      %Decision{entity: {:user, "8"}, decision: "steralize", time: ~U[1970-01-18 16:40:13.580Z]}
  """
  @spec new(map) :: __MODULE__.t
  def new(body) do
    process(body)
  end

  @doc """
  Retrieves the decisions for a given entity

  ## Parameters

    - `entity_id`: the ID of the entity you are looking to get decisions for
    - `entity_type`: The type of the entity you are looking to get decisions for (see entity_type above)

  ## Examples

      iex> Decision.decisions_for("21123865", "user")
      {:ok, %Siftsciex.Decision.Response{decisions: %{payment_abuse: %{decision: %{id: "auto_block_payment_abuse"},time: 1613777136497,webhook_succeeded: false}}}}
  """
  @spec decisions_for(String.t, entity_type) :: result
  def decisions_for(entity_id, entity_type) do
    account_id = Application.get_env(:siftsciex, :account_id)

    entity_id
    |> request_url(entity_type, account_id)
    |> @transport.get([{"Authorization", "Basic #{credentials()}"}])
    |> case do
         {:ok, %{status_code: 200} = response} ->
           {:ok, Response.process(response.body())}
         {:ok, %{status_code: status} = response} when status >= 300 and status <= 399 ->
           {:error, :redirected, response.headers["Location"]}
         {:ok, %{status_code: status}} when status >= 400 and status <= 499 ->
           Logger.error("Failed to Post Event, received 4xx response for configured URI")
           {:error, :client_error, status}
         {:ok, %{status_code: status}} when status >= 500 and status <= 500 ->
           {:error, :server_error, status}
         {:error, error} ->
           {:error, :transport_error, error.reason()}
       end
  end

  defp process(body) do
    %__MODULE__{
      entity: process_entity(body),
      decision: process_decision(body),
      time: parse_time(body)
    }
  end

  defp process_entity(%{"entity" => entity} = _body) do
    {@entity_type[entity["type"]], entity["id"]}
  end

  defp process_decision(%{"decision" => decision} = _body) do
    decision["id"]
  end

  defp parse_time(body) do
    {:ok, time} = DateTime.from_unix(body["time"], :millisecond)

    time
  end

  defp request_url(entity_id, entity_type, account_id) do
    "#{base_url()}/#{account_id}/#{entity_type}s/#{entity_id}/decisions"
  end

  # defp base_url, do: Application.get_env(:siftsciex, :score_url)
  defp base_url, do: Application.get_env(:siftsciex, :decisions_url)

  defp credentials, do: "#{Application.get_env(:siftsciex, :api_key)}:" |> Base.encode64()
end
