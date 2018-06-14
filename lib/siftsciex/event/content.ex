defmodule Siftsciex.Event.Content do
  @moduledoc """
  Sift Science supports three types of events around the creation of a Listing, _creation_, _updating_, _status changes_.  Updates and Status Changes are conceptually similar but Updates are specifically for changes to the data relating to a Listing while status changes can be more ephemerial and can indicate various lifecycle/visibility states.
  """

  import Siftsciex

  alias Siftsciex.Event.Payload.{Comment, Listing, Message, Post, Profile, Review}

  defstruct "$type": :empty,
            "$api_key": Application.get_env(:siftsciex, :api_key),
            "$user_id": :empty,
            "$content_id": :empty,
            "$account_type": :empty,
            "$session_id": :empty,
            "$status": :empty,
            "$ip": :empty,
            "$comment": :empty,
            "$listing": :empty,
            "$message": :empty,
            "$post": :empty,
            "$profile": :empty,
            "$review": :empty
  @type t :: %__MODULE__{"$type": Payload.payload_string,
                         "$api_key": String.t,
                         "$user_id": Payload.payload_string,
                         "$content_id": Payload.payload_string,
                         "$account_type": Payload.payload_string,
                         "$session_id": Payload.payload_string,
                         "$status": Payload.payload_string,
                         "$ip": Payload.payload_string,
                         "$comment": :empty | Comment.t,
                         "$listing": :empty | Listing.t,
                         "$message": :empty | Message.t,
                         "$post": :empty | Post.t,
                         "$profile": :empty | Profile.t,
                         "$review": :empty | Review.t}
  @type req_listing_key :: :user_id | :content_id
  @type opt_listing_key :: :session_id | :ip
  @type status :: :draft
                  | :pending
                  | :active
                  | :paused
                  | :deleted_by_user
                  | :deleted_by_company
  @type listing_data :: %{required(req_listing_key) => String.t,
                          required(:listing) => Listing.data,
                          optional(:status) => status,
                          optional(opt_listing_key) => String.t}

  @doc """
  Constructs a `$create_content`.`$listing` Event for Sift Science

  ## Parameters

    - `data`: The listing data (`__MODULE__.listing_data`)

  ## Examples

      iex> Content.create_listing(%{user_id: "bob", content_id: "8", status: :draft, listing: %{subject: "Chair", contact_address: %{name: "Walt", city: "Albuquerque"}, listed_items: [%{item_id: "8", price: 3, currency_code: "USD"}]}})
      %Content{"$type": "$create_content", "$api_key": "test_key", "$user_id": "bob", "$content_id": "8", "$status": "$draft", "$listing": %Siftsciex.Event.Payload.Listing{"$subject": "Chair", "$contact_address": %Siftsciex.Event.Payload.Address{"$name": "Walt", "$city": "Albuquerque"}, "$listed_items": [%Siftsciex.Event.Payload.Item{"$item_id": "8", "$price": 3000000, "$currency_code": "USD", "$quantity": 1}]}}

  """
  @spec create_listing(listing_data) :: __MODULE__.t
  def create_listing(data) do
    create()
    |> struct("$listing": Listing.new(data.listing()))
    |> populate_context(data)
  end

  defp create do
    %__MODULE__{"$type": "$create_content"}
  end

  defp populate_context(record, %{user_id: user, content_id: content} = data) do
    record
    |> struct(["$user_id": user,
               "$content_id": content,
               "$ip": lookup(data, :ip),
               "$session_id": lookup(data, :session_id),
               "$status": status(data)])
  end

  defp lookup(data, key), do: Map.get(data, key, :empty)

  defp status(%{status: status}), do: mark_string(status)
  defp status(_), do: :empty
end
