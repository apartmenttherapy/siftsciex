defmodule Siftsciex.Event.Payload.Listing do
  @moduledoc """
  This represents a `$listing` object for Sift Science
  """

  import Siftsciex, except: [api_key: 0]

  alias Siftsciex.Event.Payload
  alias Siftsciex.Event.Payload.{Address, Image, Item, Location}

  defstruct "$subject": :empty,
            "$body": :empty,
            "$contact_email": :empty,
            "$contact_address": :empty,
            "$locations": :empty,
            "$listed_items": :empty,
            "$images": :empty,
            "$expiration_time": :empty
  @type t :: %__MODULE__{"$subject": Payload.payload_string,
                         "$body": Payload.payload_string,
                         "$contact_address": :empty | Address.t,
                         "$locations": :empty | [Address.t],
                         "$listed_items": :empty | [Item.t],
                         "$images": :empty | [Image.t],
                         "$expiration_time": Payload.payload_int}
  @type string_attr :: :subject | :body
  @type data :: %{optional(string_attr) => String.t,
                  optional(:contact_address) => Address.data,
                  optional(:locations) => [Address.data],
                  optional(:listed_items) => [Item.data],
                  optional(:expiration_time) => Payload.payload_int | DateTime.t}

  @doc """
  Creates a new listing record for a Sift Science Event payload.

  ## Parameters

    - `listing`: The data for the listing (`__MODULE__.data`)

  ## Examples

      iex> Listing.new(%{subject: "Midterm"})
      %Listing{"$subject": "Midterm"}

      iex> Listing.new(%{locations: [%{city: "Albuquerque"}]})
      %Listing{"$locations": [%Siftsciex.Event.Payload.Address{"$city": "Albuquerque"}]}

      iex> Listing.new(%{listed_items: [%{item_id: "8", quantity: 1}, %{item_id: "1", quantity: 33}]})
      %Listing{"$listed_items": [%Siftsciex.Event.Payload.Item{"$item_id": "8", "$quantity": 1}, %Siftsciex.Event.Payload.Item{"$item_id": "1", "$quantity": 33}]}

  """
  @spec new(data) :: __MODULE__.t
  def new(listing) do
    normalized = Enum.map(listing, &normalize/1)

    struct(__MODULE__, normalized)
  end

  defp normalize({:subject, value}), do: {mark(:subject), value}
  defp normalize({:body, value}), do: {mark(:body), value}
  defp normalize({:locations, value}), do: {mark(:locations), Address.new(value)}
  defp normalize({:listed_items, value}), do: {mark(:listed_items), Item.new(value)}
  defp normalize({:images, value}), do: {mark(:images), Image.new(value)}
  defp normalize({:expiration_time, %DateTime{} = value}) do
    {mark(:expiration_time), DateTime.to_unix(value)}
  end
  defp normalize({:expiration_time, value}) do
    {mark(:expiration_time), value}
  end
  defp normalize({:contact_address, value}) do
    {mark(:contact_address), Address.new(value)}
  end
end
