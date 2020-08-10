defmodule Siftsciex.Verification.Response.Check do
  @moduledoc """
  Internal representation and "constructor" for a Sift Science Verficiation Check Response
  """

  defstruct status: :empty,
            message: :empty,
            checked_at: :empty
  @type t :: %__MODULE__{status: Payload.payload_int,
                         message: Payload.payload_string,
                         checked_at: :empty | DateTime.t}

  @type attributes :: :status
                      | :message
                      | :checked_at
  @type data :: %{required(attributes) => String.t}

  @spec new(data) :: __MODULE__.t
  def new(data) do
    struct(%__MODULE__{}, data)
  end
end
