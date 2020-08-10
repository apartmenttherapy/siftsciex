defmodule Siftsciex.Verification.Payload.Check do
  @moduledoc """
  Internal representation and "constructor" for a Sift Science Verficiation Check Request Payload
  """

  alias Siftsciex.Verification.Payload

  defstruct "$user_id": :empty,
            "$code": :empty
  @type t :: %__MODULE__{"$user_id": Payload.payload_string,
                         "$code": Payload.payload_string}

  @type attributes :: :user_id
                      | :code
  @type data :: %{required(attributes) => String.t}

  @spec new(data) :: __MODULE__.t
  def new(data) do
    normalized = Enum.map(data, &normalize/1)

    struct(%__MODULE__{}, normalized)
  end

  def normalize({:user_id, value}), do: {String.to_atom("$user_id"), value}
  def normalize({:code, value}), do: {String.to_atom("$code"), value}
end
