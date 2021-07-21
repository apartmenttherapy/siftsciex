defmodule Siftsciex.Verification.Response.Send do
  @moduledoc """
  Internal representation and "constructor" for a Sift Science Verficiation Send/Resend Response
  """

  defstruct status: :empty,
            message: :empty,
            sent_at: :empty,
            segment_id: :empty,
            segment_name: :empty,
            brand_name: :empty,
            site_country: :empty,
            content_language: :empty
  @type t :: %__MODULE__{status: Payload.payload_int,
                         message: Payload.payload_string,
                         sent_at: :empty | DateTime.t,
                         segment_id: Payload.payload_string,
                         segment_name: Payload.payload_string,
                         brand_name: Payload.payload_string,
                         site_country: Payload.payload_string,
                         content_language: Payload.payload_string
                        }

  @type attributes :: :status
                      | :message
                      | :checked_at
                      | :segment_id
                      | :segment_name
                      | :brand_name
                      | :site_country
                      | :content_language
  @type data :: %{required(attributes) => String.t}

  @spec new(data) :: __MODULE__.t
  def new(data) do
    struct(%__MODULE__{}, data)
  end
end
