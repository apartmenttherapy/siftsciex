defmodule Siftsciex.Score.Response.WorkflowStatus.Stage do
  @moduledoc """
  Represents an item in the `history` field in the `Siftsciex.Score.Response.WorkflowStatus.Stage.t()` struct
  """
  alias Siftsciex.Score.Response.WorkflowStatus.StageConfig

  defstruct app: :empty,
            name: :empty,
            state: :empty,
            config: :empty

  @type state :: :running | :finished | :failed

  @type t :: %__MODULE__{
    app: String.t() | :empty,
    name: String.t() | :empty,
    state: state() | :empty,
    config: StageConfig.t() | :empty
  }

  @doc """
  Converts a map to a  `t()` record or a list of maps into a list of `t()` records.

  ## Parameters
    - `data`: a map or list of maps to be converted

  ## Example

      iex> Stage.new(%{})
      %Stage{app: :empty, name: :empty, state: :empty, config: :empty}

      iex> Stage.new(%{app: "user_scorer", name: "decision", state: "finished", config: %{decision_id: "a_decision_id"}})
      %Stage{app: "user_scorer", name: "decision", state: :finished, config: %#{StageConfig}{decision_id: "a_decision_id", buttons: :empty}}

  """
  @spec new(map | [map]) :: t | [t]
  def new(data) when is_list(data), do: Enum.map(data, &parse/1)
  def new(data), do: parse(data)

  defp parse(data) do
    %__MODULE__{}
    |> struct(data)
    |> convert_config()
    |> convert_state()
  end

  defp convert_config(%{config: :empty} = record), do: record
  defp convert_config(%{config: config} = record) do
    struct(record, config: StageConfig.new(config))
  end

  defp convert_state(%{state: :empty} = record), do: record
  defp convert_state(%{state: state} = record) do
    struct(record, state: String.to_existing_atom(state))
  end
end
