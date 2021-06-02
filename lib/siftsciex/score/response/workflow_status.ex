defmodule Siftsciex.Score.Response.WorkflowStatus do
  @moduledoc """
  Represents an item in the `workflow_statuses`  field in the
  `Siftsciex.Score.Response.t()` struct
  """
  alias __MODULE__.{Config, Entity, Stage}

  defstruct id: :empty,
            state: :empty,
            abuse_types: :empty,
            config: :empty,
            config_display_name: :empty,
            entity: :empty,
            history: :empty

  @type abuse_type :: :payment_abuse | :promotion_abuse | :content_abuse | :account_abuse | :account_takeover | :legacy

  @type t :: %__MODULE__{
    id: String.t(),
    state: :running | :finishd | :failed | :empty,
    abuse_types: [abuse_type()] | :empty,
    config: Config.t() | :empty,
    config_display_name: String.t() | :empty,
    entity: Entity.t() | :empty,
    history: [Stage.t()] | :empty
  }

  @doc """
  Converts a map to a  `t()` record or a list of maps into a list of `t()` records.

  ## Parameters
    - `data`: a map or list of maps

  ## Examples

      iex> WorkflowStatus.new(%{id: "an-id", state: "finished", entity: %{id: "entity-id", type: "content"}})
      %WorkflowStatus{abuse_types: :empty, config: :empty, config_display_name: :empty, entity: %#{Entity}{id: "entity-id", type: :content}, history: :empty, id: "an-id", state: :finished}

  """
  @spec new(map | [map]) :: t | [t]
  def new(data) when is_list(data), do: Enum.map(data, &convert/1)
  def new(data), do: convert(data)

  defp convert(data) do
    %__MODULE__{}
    |> struct(data)
    |> convert_app()
    |> convert_abuse_types()
    |> convert_config()
    |> convert_entity()
    |> convert_history()
  end

  defp convert_app(%{state: :empty} = record), do: record
  defp convert_app(%{state: state} = record) do
    struct(record, state: String.to_existing_atom(state))
  end

  defp convert_abuse_types(%{abuse_types: :empty} = record), do: record
  defp convert_abuse_types(%{abuse_types: abuse_types} = record) do
    struct(record, abuse_types: Enum.map(abuse_types, &String.to_existing_atom/1))
  end

  defp convert_config(%{config: :empty} = record), do: record
  defp convert_config(%{config: config} = record) do
    struct(record, config: Config.new(config))
  end

  defp convert_entity(%{entity: :empty} = record), do: record
  defp convert_entity(%{entity: entity} = record) do
    struct(record, entity: Entity.new(entity))
  end

  defp convert_history(%{history: :empty} = record), do: record
  defp convert_history(%{history: history} = record) do
    struct(record, history: Stage.new(history))
  end
end
