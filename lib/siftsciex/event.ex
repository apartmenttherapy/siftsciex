defmodule Siftsciex.Event do
  @moduledoc """
  The Event module is used for registering events with SiftScience.
  """

  require Logger

  alias Siftsciex.Event.{Account, Content, Response, Transport}

  defstruct "$type": :empty, "$api_key": :empty, "$user_id": :empty, "$content_id": :empty, "$session_id": :empty, "$status": :empty, "$ip": :empty
  @type error_map :: %{required(String.t) => String.t}
  @type result :: {:ok, Response.t}
                  | {:error, :redirected, String.t}
                  | {:error, :client_error, integer}
                  | {:error, :server_error, integer}
                  | {:error, :transport_error, any}

  @doc """
  Reports a `create_content.listing` event to Sift Science

  ## Parameters

    - `data`: The data for the newly created listing
      * `:subject`
      * `:body`
      * `:contact_email`
      * `:contact_address`
      * `:locations`
      * `:listed_items`
      * `:images`
      * `:expiration_time`
      * `:ip`
      * `:status`
      * `:session_id`
      * `:content_id`
      * `:user_id`

  ## Examples

      iex> Event.create_listing(%{user_id: "bob", content_id: "8", status: :draft, listing: %{subject: "Chair", contact_address: %{name: "Walt", city: "Albuquerque"}, listed_items: [%{item_id: "8", price: 3, currency_code: "USD"}]}})
      {:ok, %Siftsciex.Event.Response{}}

  """
  @spec create_listing(map) :: result
  def create_listing(data) do
    data
    |> Content.create_listing()
    |> purge_empty()
    |> post()
  end

  @doc """
  Register a `$create_account` Event with Sift Science

  ## Parameters

    - `data`: The account data that should be sent to Sift Science

  ## Examples

      iex> Event.create_account(%{user_id: "bob", user_email: "bob@example.com"})
      {:ok, %Siftsciex.Event.Response{}}

  """
  @spec create_account(map) :: result
  def create_account(data) do
    data
    |> Account.create_account()
    |> purge_empty()
    |> post()
  end

  @doc """
  Register a `$create_content`.`$message` Event with Sift Science

  ## Parameters

    - `data`: The message data that should be sent to Sift Science

  ## Examples

      iex> Event.create_message(%{content_id: "9f2ebfb3-7dbb-456c-b263-d985f107de07", message: %{body: "Hello"}})
      {:ok, %Siftsciex.Event.Response{}}

  """
  @spec create_message(map) :: result
  def create_message(data) do
    data
    |> Message.create_message()
    |> purge_empty()
    |> post()
  end

  defp post(payload) do
    payload
    |> Transport.post()
    |> case do
         {:ok, %{status_code: 200} = response} ->
           {:ok, Response.process(response.body())}
         {:ok, %{status_code: status} = response} when status >= 300 and status <= 399 ->
           {:error, :redirected, response.headers["Location"]}
         {:ok, %{status_code: status}} when status >= 400 and status <= 499 ->
           Logger.error("Failed to Post Event, received 4xx response for configured URI")
           {:error, :client_error, status}
         {:ok, %{status_code: status}} when status >= 500 and status <= 500 ->
           {:error, :server_error, status}
         {:error, error} ->
           {:error, :transport_error, error.reason()}
       end
  end

  @doc """
  Purges all keys with `:empty` values from the given map.

  ## Parameters

    - `record`: The record that should be purged

  ## Examples

      iex> Event.purge_empty(%{"$type": "$create_content", "$ip": :empty})
      %{"$type": "$create_content"}

      iex> Event.purge_empty(%{"$type": "$create_content", "$listing": %{"$subject": "Table", "$contact_address": :empty}})
      %{"$type": "$create_content", "$listing": %{"$subject": "Table"}}

      iex> Event.purge_empty(%{"$type": "$create_content", "$listing": %{"$listed_items": [%{"$price": 5000000, "$currency_code": :empty}]}})
      %{"$type": "$create_content", "$listing": %{"$listed_items": [%{"$price": 5000000}]}}

  """
  @spec purge_empty(map) :: map
  def purge_empty(%_{} = record) do
    record
    |> Map.from_struct()
    |> purge_empty()
  end
  def purge_empty(record) when is_list(record) do
    record
    |> Enum.reduce([], fn element, collection ->
         case element do
           :empty -> collection
           e when is_binary(e) -> [e] ++ collection
           e -> [purge_empty(e)] ++ collection
         end
       end)
  end
  def purge_empty(record) do
    Enum.reduce(record, %{}, fn {key, value}, stripped ->
      case value do
        %{} = value ->
          Map.put(stripped, key, purge_empty(value))
        value when is_list(value) ->
          Map.put(stripped, key, purge_empty(value))
        :empty ->
          stripped
        value ->
          Map.put(stripped, key, value)
      end
    end)
  end
end
