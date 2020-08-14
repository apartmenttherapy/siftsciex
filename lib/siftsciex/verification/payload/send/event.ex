defmodule Siftsciex.Verification.Payload.Send.Event do
  @moduledoc """
  Internal representation and "constructor" for a Sift Science Verficiation Send Request Event Payload
  """

  defstruct "$verified_event": :empty,
            "$session_id": :empty
  @type t :: %__MODULE__{"$verified_event": Payload.payload_string,
                         "$session_id": Payload.payload_string}

  @type attributes :: :verified_event
                      | :session_id
  @type data :: %{required(attributes) => String.t}

  @spec new(data) :: __MODULE__.t
  def new(data) do
    normalized = Enum.map(data, &normalize/1)

    struct(%__MODULE__{}, normalized)
  end

  def normalize({:verified_event, value}), do: {String.to_atom("$verified_event"), value}
  def normalize({:session_id, value}), do: {String.to_atom("$session_id"), value}
end
