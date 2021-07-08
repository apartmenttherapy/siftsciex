defmodule Siftsciex.Verification.Payload.Resend do
  @moduledoc """
  Internal representation and "constructor" for a Sift Science Verficiation Resend Request Payload
  """

  alias Siftsciex.Verification.Payload

  defstruct "$user_id": :empty,
            "$verified_entity_id": :empty
  @type t :: %__MODULE__{"$user_id": Payload.payload_string,
                         "$verified_entity_id": Payload.payload_string}

  @type attributes :: :user_id
                      | :verified_entity_id
  @type data :: %{required(attributes) => String.t}

  @spec new(data) :: __MODULE__.t
  def new(data) do
    normalized = Enum.map(data, &normalize/1)

    struct(%__MODULE__{}, normalized)
  end

  def normalize({:user_id, value}), do: {String.to_atom("$user_id"), value}
  def normalize({:verified_entity_id, value}), do: {String.to_atom("$verified_entity_id"), value}
end
