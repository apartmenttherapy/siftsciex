defmodule Siftsciex.Score.Response.WorkflowStatus.Config do
  @moduledoc """
  Represents the `config`  field in the `Siftsciex.Score.Response.WorkflowStatus.t()` struct
  """

  defstruct id: :empty, version: :empty

  @type t :: %__MODULE__{
          id: String.t() | :empty,
          version: String.t() | :empty
        }

  @doc """
  Converts a map into a `t()` struct.

  ## Parameters

    - map: a map that should be converted to the `t()` struct.

  ## Examples

      iex> Config.new(%{id: "some-id", version: "some-version"})
      %Config{id: "some-id", version: "some-version"}

  """
  @spec new(map) :: t
  def new(data), do: struct(__MODULE__, data)
end
