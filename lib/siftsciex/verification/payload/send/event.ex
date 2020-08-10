defmodule Siftsciex.Verification.Payload.Send.Event do
  @moduledoc """
  Internal representation and "constructor" for a Sift Science Verficiation Send Request Event Payload
  """

  alias Siftsciex.Verification.Payload.Send.Event

  defstruct "$verified_event": :empty

  @type t :: %__MODULE__{"$verified_event": Payload.payload_string}

  @type attributes :: :verified_event

  @type data :: %{required(attributes) => String.t}

  @spec new(data) :: __MODULE__.t
  def new(data) do
    normalized = Enum.map(data, &normalize/1)

    struct(%__MODULE__{}, normalized)
  end

  def normalize({:verified_event, value}), do: {String.to_atom("$verified_event"), value}
end
