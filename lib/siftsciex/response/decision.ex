defmodule Siftsciex.Response.Decision do
  @moduledoc """

  """

  defstruct [:entity, :decision, :time]
  @type t :: %__MODULE__{entity: entity, decision: String.t, time: DateTime.t}
  @type entity :: {entity_type, String.t}

  @type entity_type :: :user | :order | :session | :content
  @entity_type %{"user" => :user,
                 "order" => :order,
                 "session" => :session,
                 "content" => :content}

  @doc """
  Creates a new `__MODULE__.t` struct from the given map (parsed JSON)

  ## Parameters

    - `body`: A map representing the parsed JSON for a Sift Science Decision

  ## Examples

      iex> Decision.new(%{"entity" => %{"type" => "user", "id" => "8"}, "decision" => %{"id" => "steralize"}, "time" => 1528813580})
      %Decision{entity: {:user, "8"}, decision: "steralize", time: #DateTime<2018-06-12 14:26:20Z>}

  """
  @spec new(map) :: __MODULE__.t
  def new(body) do
    process(body)
  end

  defp process(body) do
    %__MODULE__{
      entity: process_entity(body),
      decision: process_decision(body),
      time: parse_time(body)
    }
  end

  defp process_entity(%{"entity" => entity} = body) do
    {@entity_type[entity["type"]], entity["id"]}
  end

  defp process_decision(%{"decision" => decision} = body) do
    decision["id"]
  end

  defp parse_time(body) do
    {:ok, time} = DateTime.from_unix(body["time"])

    time
  end
end
