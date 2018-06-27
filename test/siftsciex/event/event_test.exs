defmodule Siftsciex.EventTest do
  use ExUnit.Case

  alias Siftsciex.Event
  alias Siftsciex.Event.Response

  doctest Event, except: [create_account: 2,
                          create_listing: 2,
                          create_message: 2,
                          update_listing: 2,
                          update_account: 2,
                          update_message: 2]

  test "create_account/1 sends a $create_account Event to Sift Science" do
    assert {:ok, %Response{}} = Event.create_account(account_data())
  end

  test "create_listing/1 sends a $create_content -> $listing Event to Sift Science" do
    assert {:ok, %Response{}} = Event.create_listing(listing_data())
  end

  test "create_message/1 sends a $create_content -> $message Event to Sift Science" do
    assert {:ok, %Response{}} = Event.create_message(message_data())
  end

  test "update_listing/1 sends an $update_content -> $listing Event to Sift Science" do
    assert {:ok, %Response{}} = Event.update_listing(listing_data())
  end

  test "update_account/1 sends an $update_account Event to Sift Science" do
    assert {:ok, %Response{}} = Event.update_account(account_data())
  end

  test "update_message/1 sends an $update_content -> $message Event to Sift Science" do
    assert {:ok, %Response{}} = Event.update_message(message_data())
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

  def message_data do
    %{user_id: "bob",
      content_id: "9f2ebfb3-7dbb-456c-b263-d985f107de07",
      message: %{body: "Hello"}}
  end
end
