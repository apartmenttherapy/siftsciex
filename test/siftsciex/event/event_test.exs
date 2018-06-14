defmodule Siftsciex.EventTest do
  use ExUnit.Case

  alias Siftsciex.Event
  alias Siftsciex.Event.Response

  doctest Event, except: [create_account: 1, create_listing: 1]

  test "create_account/1 sends a $create_account Event to Sift Science" do
    assert {:ok, %Response{}} = Event.create_account(account_data())
  end

  test "create_listing/1 sends a $create_content -> $listing Event to Sift Science" do
    assert {:ok, %Response{}} = Event.create_listing(listing_data())
  end

  def account_data, do: %{user_id: "bob", user_email: "bob@example.com"}

  def listing_data do
    %{user_id: "bob",
      content_id: "8",
      status: :draft,
      listing: %{subject: "Chair",
        contact_address: %{name: "Walt",
          city: "Albuquerque"},
        listed_items: [%{item_id: "8", price: 3, currency_code: "USD"}]
      }
    }
  end
end
