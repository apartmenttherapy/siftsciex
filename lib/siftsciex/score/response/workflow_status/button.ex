defmodule Siftsciex.Score.Response.WorkflowStatus.Button do
  @moduledoc """
  Represents the `buttons`  field in the `Siftsciex.Score.Response.WorkflowStatus.StageConfig.t()` struct
  """
  defstruct id: :empty, name: :empty

  @type t :: %__MODULE__{
          id: String.t() | :empty,
          name: String.t() | :empty
        }


  @doc """
  Converts a map or a list of maps to a `t()` struct or a list of `t()` structs.

  ## Parameters
    - data: a map or list of maps that should be converted to the `t()` struct

  ## Example

      iex> Button.new(%{id: "An Id", name: "A button name"})
      %Button{id: "An Id", name: "A button name"}

      iex> Button.new([%{id: "An Id", name: "A button name"}, %{id: "Another Id", name: "Another button name"}])
      [%Button{id: "An Id", name: "A button name"}, %Button{id: "Another Id", name: "Another button name"}]

  """
  @spec new(map() | [map()]) :: t() | [t()]
  def new(data) when is_list(data), do: Enum.map(data, &parse/1)
  def new(data), do: parse(data)

  defp parse(data) do
    struct(%__MODULE__{}, data)
  end
end
