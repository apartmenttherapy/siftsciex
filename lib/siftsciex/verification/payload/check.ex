defmodule Siftsciex.Verification.Payload.Check do
  @moduledoc """
  Internal representation and "constructor" for a Sift Science Verficiation Check Request Payload
  """

  alias Siftsciex.Verification.Payload

  defstruct "$user_id": :empty,
            "$code": :empty,
            "$verified_event": :empty,
            "$verified_entity_id": :empty
  @type t :: %__MODULE__{"$user_id": Payload.payload_string,
                         "$code": Payload.payload_string,
                         "$verified_event": Payload.payload_string,
                         "$verified_entity_id": Payload.payload_string}

  @type attributes :: :user_id
                      | :code
                      | :verified_event
                      | :verified_entity_id
  @type data :: %{required(attributes) => String.t}

  @spec new(data) :: __MODULE__.t
  def new(data) do
    normalized = Enum.map(data, &normalize/1)

    struct(%__MODULE__{}, normalized)
  end

  def normalize({:user_id, value}), do: {String.to_atom("$user_id"), value}
  def normalize({:code, value}), do: {String.to_atom("$code"), value}
  def normalize({:verified_event, value}), do: {String.to_atom("$verified_event"), value}
  def normalize({:verified_entity_id, value}), do: {String.to_atom("$verified_entity_id"), value}
end
