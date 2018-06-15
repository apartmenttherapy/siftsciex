defmodule Siftsciex.Event.Payload.Image do
  @moduledoc """
  An image for Sift Science
  """

  alias Siftsciex.Event.Payload

  defstruct "$md5_hash": :empty, "$link": :empty, "$description": :empty
  @type t :: %__MODULE__{"$md5_hash": Payload.payload_string,
                         "$link": Payload.payload_string,
                         "$description": Payload.payload_string}

  @type data :: %{md5: String.t,
                  link: String.t,
                  description: String.t}

  @doc """
  Creates a new `t:Siftsciex.Event.Payload.Image.t/0` struct for use in an Event Payload.

  ## Parameters

    - `data`: The image data, this should be in the form of a `t:Siftsciex.Event.Payload.Image.data/0` map

  ## Examples

      iex> Image.new(%{md5: "5", link: "https://example.com", description: "Image"})
      %Image{"$md5_hash": "5", "$link": "https://example.com", "$description": "Image"}

      iex> Image.new([%{md5: "5", link: "https://example.com"}, %{md5: "6", description: "Image"}])
      [%Image{"$md5_hash": "5", "$link": "https://example.com"}, %Image{"$md5_hash": "6", "$description": "Image"}]

  """
  @spec new(data) :: __MODULE__.t
  def new(data) when is_list(data) do
    Enum.map(data, &(new(&1)))
  end
  def new(data) do
    mapped = Enum.map(data, &convert/1)

    struct(%__MODULE__{}, mapped)
  end

  defp convert({:md5, value}), do: {String.to_atom("$md5_hash"), value}
  defp convert({:link, value}), do: {String.to_atom("$link"), value}
  defp convert({:description, value}), do: {String.to_atom("$description"), value}
end
