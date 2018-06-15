defmodule Siftsciex.Event.Payload.Message do
  @moduledoc false

  alias Siftsciex.Event.Payload
  alias Siftsciex.Event.Payload.Image

  defstruct "$body": :empty,
            "$contact_email": :empty,
            "$recipient_user_ids": [],
            "$root_content_id": :empty,
            "$images": []
  @type t :: %__MODULE__{"$body": Payload.payload_string,
                         "$contact_email": Payload.payload_string,
                         "$recipient_user_ids": list,
                         "$root_content_id": Payload.payload_string,
                         "$images": [Image.t]}
  @type message_data :: %{body: String.t,
                          contact_email: String.t,
                          recipient_ids: [String.t],
                          root_content_id: String.t,
                          subject_id: String.t,
                          images: [Image.data]}
                        | [body: String.t,
                           contact_email: String.t,
                           recipient_ids: [String.t],
                           subject_id: String.t,
                           images: [Image.data]]
  @type message_image :: %{md5: String.t,
                           link: String.t,
                           description: String.t}

  @doc """
  Builds a new Sift Science payload struct for a `message`

  ## Parameters

    - `data`: The data that should be provided to Sift Science for the message (`t:Siftsciex.Event.Payload.Message.message_data/0`)

  ## Examples

      iex> Message.new(%{body: "Hi", contact_email: "me@example.com", recipient_ids: ["you@example.com"], subject_id: "88354", images: [%{md5: "0", link: "https://example.com", description: "Image"}]})
      %Message{"$body": "Hi", "$contact_email": "me@example.com", "$recipient_user_ids": ["you@example.com"], "$root_content_id": "88354", "$images": [%Image{"$md5_hash": "0", "$link": "https://example.com", "$description": "Image"}]}

      iex> Message.new([body: "Hi", contact_email: "me@example.com", recipient_ids: ["you@example.com"], subject_id: "88354", images: []])
      %Message{"$body": "Hi", "$contact_email": "me@example.com", "$recipient_user_ids": ["you@example.com"], "$root_content_id": "88354", "$images": []}

  """
  @spec new(message_data) :: __MODULE__.t
  def new(data) do
    mapped = Enum.map(data, &convert/1)

    struct(%__MODULE__{}, mapped)
  end

  defp convert({:body, value}), do: {String.to_atom("$body"), value}
  defp convert({:root_content_id, value}), do: {String.to_atom("$root_content_id"), value}
  defp convert({:contact_email, value}), do: {String.to_atom("$contact_email"), value}
  defp convert({:subject_id, value}), do: {String.to_atom("$root_content_id"), value}
  defp convert({:images, values}) do
    key = String.to_atom("$images")

    {key, convert_images(values, [])}
  end
  defp convert({:recipient_ids, value}) do
    {String.to_atom("$recipient_user_ids"), value}
  end

  defp convert_images([], converted), do: converted
  defp convert_images([image | rest], converted) do
    convert_images(rest, [Image.new(image)] ++ converted)
  end
end
