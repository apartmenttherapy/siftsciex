defmodule Siftsciex.Score.Response.WorkflowStatus.StageConfig do
  @moduledoc """
  Represents the `config`  field in the `Siftsciex.Score.Response.WorkflowStatus.Stage.t()` struct
  """
  alias Siftsciex.Score.Response.WorkflowStatus.Button

  defstruct decision_id: :empty,
            buttons: :empty

  @type t :: %__MODULE__{
    decision_id: String.t | :empty,
    buttons: [Button.t] | :empy
  }

  @doc """
  Converts a map into a `t()` struct.

  ## Parameters

    - map: a map that should be converted to the `t()` struct.

  ## Examples

      iex> StageConfig.new(%{decision_id: "some-id", buttons: [%{id: "button-id", name: "button-name"}]})
      %StageConfig{decision_id: "some-id", buttons: [%#{Button}{id: "button-id", name: "button-name"}]}

  """
  @spec new(map()) :: t()
  def new(data) do
    %__MODULE__{}
    |> struct(data)
    |> convert_buttons()
  end

  defp convert_buttons(%{buttons: :empty} = record), do: record
  defp convert_buttons(%{buttons: buttons} = record) do
    struct(record, buttons: Button.new(buttons))
  end
end
