defmodule Siftsciex.Event do
  @moduledoc """
  The Event module is used for registering events with SiftScience.

  Events are the crux of what Sift Science does, they represent user activity in your application.  Things like creating a listing, or message as well as initiating a payment or signing up are all Events.  Sift Science analyzes the data sent with the Events to build a Risk Score indicating how likely it is that that user is an honest agent.

  When delivering Event data you can request an immediate (synchronous) risk score or you can simply deliver the data then either check the Risk score independently or setup Workflows in Sift Science which can deliver Score results to a Webhook in your application if specific criteria are met.

  Currently `Siftsciex` supports the following Events:

    * `create_account`
    * `create_listing`
    * `create_message`
    * `update_account`
    * `update_listing`
    * `update_message`

  The `Event` functions all return a `t:Siftsciex.Event.result/0` tuple.  The first element in the tuple is an atom indicative of the HTTP transport result.  `:ok` means that the HTTP delivery was successful (2xx HTTP response).  In the case of an `:ok` as the first element the second element will be a `t:Siftsciex.Event.Response.t/0` struct.

  There are several different `:error` possibilities, the following are possible HTTP level errors when it comes to `Siftsciex`:

    * `:redirected`
    * `:client_error`
    * `:server_error`
    * `:transport_error`

  In the case of an `:error` response the second element in the tuple will be one of the above and there will be a third element providing a bit more information about the specific error.

  ### Options

  All the functions in this module accept an optional `opts` argument which can be used to indicate that the given Event shuld be synchronous and the specified abuse scores should be returned.

  If provided options should have one key `:scores` with a list of `t:Siftsciex.Score.abuse_type/0` values indicating which scores should be returned in the response to the Event report.

  """

  require Logger

  alias Siftsciex.Event.{Account, Content, Error, Login, Response, Transport}

  @type error_map :: %{required(String.t) => String.t}
  @type result :: {:ok, Response.t} | {:error, Error.t}

  @doc """
  Reports a `create_content.listing` event to Sift Science

  ## Parameters

    - `data`: The data for the newly created listing see `t:Siftsciex.Event.Content.listing_data/0` for details on the keys expected.
    - `opts`: See the Options section in the module description.

  ## Examples

      iex> Event.create_listing(%{user_id: "bob", content_id: "8", status: :draft, listing: %{subject: "Chair", contact_address: %{name: "Walt", city: "Albuquerque"}, listed_items: [%{item_id: "8", price: 3, currency_code: "USD"}]}})
      {:ok, %Siftsciex.Event.Response{}}

  """
  @spec create_listing(map, Keyword.t) :: result
  def create_listing(data, opts \\ []) do
    data
    |> Content.create_listing()
    |> purge_empty()
    |> post(opts)
  end

  @doc """
  Reports an `$update_content`.`$listing` event to Sift Science

  ## Parameters

    - `data`: The data for the updated listing
    - `opts`: See the Options section in the module description.

  ## Examples

      iex> Event.create_listing(%{user_id: "bob", content_id: "8", status: :draft, listing: %{subject: "Chair", contact_address: %{name: "Walt", city: "Albuquerque"}, listed_items: [%{item_id: "8", price: 3, currency_code: "USD"}]}})
      {:ok, %Siftsciex.Event.Response{}}

  """
  @spec update_listing(map, Keyword.t) :: result
  def update_listing(data, opts \\ []) do
    data
    |> Content.update_listing()
    |> purge_empty()
    |> post(opts)
  end

  @doc """
  Register a `$create_account` Event with Sift Science

  ## Parameters

    - `data`: The account data that should be sent to Sift Science
    - `opts`: See the Options section in the module description.

  ## Examples

      iex> Event.create_account(%{user_id: "bob", user_email: "bob@example.com"})
      {:ok, %Siftsciex.Event.Response{}}

  """
  @spec create_account(map, Keyword.t) :: result
  def create_account(data, opts \\ []) do
    data
    |> Account.create_account()
    |> purge_empty()
    |> post(opts)
  end

  @doc """
  Register an `$update_account` Event with Sift Science

  ## Parameters

    - `data`: The account data that has been updated
    - `opts`: See the Options section in the module description.

  ## Examples

      iex> Event.update_account(%{user_id: "bob", user_email: "bob2@example.com"})
      {:ok, %Siftsciex.Event.Response{}}

  """
  @spec update_account(map, Keyword.t) :: result
  def update_account(data, opts \\ []) do
    data
    |> Account.update_account()
    |> purge_empty()
    |> post(opts)
  end

  @doc """
  Register an `$login` Event with Sift Science

  ## Parameters

    - `data`: A map with all parameters that should be sent to Sift Science
    - `options`: See the Options section in the module description.

  ## Examples
      iex> Event.login(%{user_id: "kate.austin", login_status: :success})
      {:ok, %Siftsciex.Event.Response{}}

  """
  @spec login(map(), Keyword.t()) :: result()
  def login(data, opts \\ []) do
    with {:ok, login_event} <- Login.create(data) do
      login_event
      |> purge_empty()
      |> post(opts)
    else
      {:error, error} ->
        {:error, :client_error, error}
    end
  end

  @doc """
  Register a `$create_content`.`$message` Event with Sift Science

  ## Parameters

    - `data`: The message data that should be sent to Sift Science
    - `opts`: See the Options section in the module description.

  ## Examples

      iex> Event.create_message(%{user_id: "auth0|bob", content_id: "9f2ebfb3-7dbb-456c-b263-d985f107de07", message: %{body: "Hello"}})
      {:ok, %Siftsciex.Event.Response{}}

  """
  @spec create_message(map, Keyword.t) :: result
  def create_message(data, opts \\ []) do
    data
    |> Content.create_message()
    |> purge_empty()
    |> post(opts)
  end

  @doc """
  Register an `$update_content`.`$message` Event with Sift Science

  ## Parameters

    - `data`: The message data that should be sent
    - `opts`: See the Options section in the module description.

  ## Examples

      iex> Event.update_message(%{user_id: "auth0|bob", content_id: "9f2ebfb3-7dbb-456c-b263-d985f107de07", message: %{body: "Bye"}})
      {:ok, %Siftsciex.Event.Response{}}

  """
  @spec update_message(map, Keyword.t) :: result
  def update_message(data, opts \\ []) do
    data
    |> Content.update_message()
    |> purge_empty()
    |> post(opts)
  end

  defp post(payload, opts) do
    payload
    |> Transport.post(opts)
    |> process_response()
  end

  defp process_response(response) do
    case response do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, Response.process(body)}

      {:ok, %{status_code: status, headers: headers}} when status >= 300 and status <= 399 ->
        {:error, Error.build(:redirected, headers["Location"])}

      {:ok, %{status_code: status, body: body}} when status >= 400 and status <= 499 ->
        Logger.error("Failed to Post Event, received 4xx response for configured URI")
        {:error, Error.from_body(:client_error, body)}

      {:ok, %{status_code: status, body: body}} when status >= 500 and status <= 500 ->
        {:error, Error.from_body(:server_error, body)}

      {:error, %{reason: reason}} ->
        {:error, Error.build(:transport_error, reason)}
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
  @spec purge_empty(map | list) :: map
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
