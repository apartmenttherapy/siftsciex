defmodule Siftsciex.Body.Event.Image do
  @moduledoc """
  An image for Sift Science
  """

  alias Siftsciex.Body

  defstruct "$md5_hash": :empty, "$link": :empty, "$description": :empty
  @type t :: %__MODULE__{"$md5_hash": Body.payload_string,
                         "$link": Body.payload_string,
                         "$description": Body.payload_string}

  @type data :: %{md5: String.t,
                  link: String.t,
                  description: String.t}

  @doc """
  Creates a new `__MODULE__.t` struct for use in an Event Payload.

  ## Parameters

    - `data`: The image data, this should be in the form of a `__MODULE__.image_data` map

  ## Examples

      iex> Image.new(%{md5: "5", link: "https://example.com", description: "Image"})
      %Image{"$md5_hash": "5", "$link": "https://example.com", "$description": "Image"}

  """
  @spec new(data) :: __MODULE__.t
  def new(data) do
    mapped = Enum.map(data, &convert/1)

    struct(%__MODULE__{}, mapped)
  end

  defp convert({:md5, value}), do: {String.to_atom("$md5_hash"), value}
  defp convert({:link, value}), do: {String.to_atom("$link"), value}
  defp convert({:description, value}), do: {String.to_atom("$description"), value}
end
