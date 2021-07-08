defmodule Siftsciex.Score.Response.WorkflowStatus.Entity do
  @moduledoc """
  Represents the `entity`  field in the `Siftsciex.Score.Response.WorkflowStatus.t()` struct
  """

  defstruct id: :empty, type: :empty

  @type type :: :user | :order | :content | :session
  @type t :: %__MODULE__{
          id: String.t() | :empty,
          type: type() | :empty
        }

  @doc """
  Converts a map into a `t()` struct.

  ## Parameters

    - map: a map that should be converted to the `t()` struct.

  ## Examples

      iex> Entity.new(%{id: "some-id", type: "session"})
      %Entity{id: "some-id", type: :session}

  """
  @spec new(map()) :: t()
  def new(data) do
    %__MODULE__{}
    |> struct(data)
    |> convert_type()
  end

  defp convert_type(%{type: :empty} = record), do: record
  defp convert_type(%{type: type} = record) do
    struct(record, type: String.to_existing_atom(type))
  end
end
