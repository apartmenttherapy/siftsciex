defmodule Siftsciex.Verification.Payload.Send do
  @moduledoc """
  Internal representation and "constructor" for a Sift Science Verficiation Send Request Payload
  """

  alias Siftsciex.Verification.Payload
  alias Siftsciex.Verification.Payload.Send

  defstruct "$user_id": :empty,
            "$send_to": :empty,
            "$verification_type": :empty,
            "$brand_name": :empty,
            "$event": :empty
  @type t :: %__MODULE__{"$user_id": Payload.payload_string,
                         "$send_to": Payload.payload_string,
                         "$verification_type": Payload.payload_string,
                         "$brand_name": Payload.payload_string,
                         "$event": Send.Event}

  @type attributes :: :user_id
                      | :send_to
                      | :verification_type
                      | :brand_name
  @type data :: %{required(attributes) => String.t}

  @spec new(data) :: __MODULE__.t
  def new(data) do
    normalized = Enum.map(data, &normalize/1)

    struct(%__MODULE__{}, normalized)
  end

  def normalize({:user_id, value}), do: {String.to_atom("$user_id"), value}
  def normalize({:send_to, value}), do: {String.to_atom("$send_to"), value}
  def normalize({:verification_type, value}), do: {String.to_atom("$verification_type"), value}
  def normalize({:brand_name, value}), do: {String.to_atom("$brand_name"), value}
  def normalize({:event, value}), do: {String.to_atom("$event"), Send.Event.new(value)}
end
