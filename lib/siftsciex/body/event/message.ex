defmodule Siftsciex.Body.Event.Message do
  @moduledoc false

  defstruct "$body": :empty,
            "$contact_email": :empty,
            "$recipient_user_ids": [],
            "$root_content_id": :empty,
            "$images": []
  @type t :: %__MODULE__{"$body": :empty | String.t,
                         "$contact_email": :empty | String.t,
                         "$recipient_user_ids": list,
                         "$root_content_id": :empty | String.t,
                         "$images": list}
  @type message_data :: %{body: String.t,
                          contact_email: String.t,
                          recipient_ids: [String.t],
                          subject_id: String.t,
                          images: [message_image]}
                        | [body: String.t,
                           contact_email: String.t,
                           recipient_ids: [String.t],
                           subject_id: String.t,
                           images: [message_image]]
  @type message_image :: %{md5: String.t,
                           link: String.t,
                           description: String.t}

  @doc """
  Builds a new Sift Science payload struct for a `message`

  ## Parameters

    - `data`: The data that should be provided to Sift Science for the message (`__MODULE__.message_data`)

  ## Examples

      iex> Message.new(%{body: "Hi", contact_email: "me@example.com", recipient_ids: ["you@example.com"], subject_id: "88354", images: [%{md5: "0", link: "https://example.com", description: "Image"}]})
      %Message{"$body": "Hi", "$contact_email": "me@example.com", "$recipient_user_ids": ["you@example.com"], "$root_content_id": "88354", "$images": [%{"$md5_hash": "0", "$link": "https://example.com", "$description": "Image"}]}

      iex> Message.new([body: "Hi", contact_email: "me@example.com", recipient_ids: ["you@example.com"], subject_id: "88354", images: []])
      %Message{"$body": "Hi", "$contact_email": "me@example.com", "$recipient_user_ids": ["you@example.com"], "$root_content_id": "88354", "$images": []}

  """
  @spec new(message_data) :: __MODULE__.t
  def new(data) do
    mapped = Enum.map(data, &convert/1)

    struct(%__MODULE__{}, mapped)
  end

  defp convert({:body, value}), do: {String.to_atom("$body"), value}
  defp convert({:contact_email, value}), do: {String.to_atom("$contact_email"), value}
  defp convert({:subject_id, value}), do: {String.to_atom("$root_content_id"), value}
  defp convert({:images, values}), do: {String.to_atom("$images"), convert(values, [])}
  defp convert({:recipient_ids, value}) do
    {String.to_atom("$recipient_user_ids"), value}
  end

  defp convert([], converted) do
    converted
  end
  defp convert([image | rest], converted) do
    remapped = Enum.reduce(image, %{}, fn part, remapped ->
                 {key, value} = convert_image(part)
                 Map.put(remapped, key, value)
               end)

    convert(rest, [remapped] ++ converted)
  end

  defp convert_image({:md5, value}), do: {String.to_atom("$md5_hash"), value}
  defp convert_image({:link, value}), do: {String.to_atom("$link"), value}
  defp convert_image({:description, value}), do: {String.to_atom("$description"), value}
end
