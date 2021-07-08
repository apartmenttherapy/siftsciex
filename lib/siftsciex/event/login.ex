defmodule Siftsciex.Event.Login do
  @moduledoc """
  Functions for managing the login event on Sift Science.
  """
  import Siftsciex

  alias Siftsciex.Event.Payload
  alias Siftsciex.Event.Payload.{App, Browser}

  defstruct "$type": "$login",
            "$api_key": api_key(),
            "$user_id": :empty,
            "$session_id": :empty,
            "$login_status": :empty,
            "$user_email": :empty,
            "$ip": :empty,
            "$browser": :empty,
            "$app": :empty,
            "$failure_reason": :empty,
            "$username": :empty,
            "$social_sign_on_type": :empty,
            "$account_types": :empty,
            "$brand_name": :empty,
            "$site_country": :empty,
            "$site_domain": :empty

  @type t :: %__MODULE__{
          "$type": String.t(),
          "$api_key": String.t(),
          "$user_id": String.t(),
          "$session_id": Payload.payload_string(),
          "$login_status": String.t(),
          "$user_email": Payload.payload_string(),
          "$ip": Payload.payload_string(),
          "$browser": :empty,
          "$app": :empty,
          "$failure_reason": :empty,
          "$username": :empty,
          "$social_sign_on_type": :empty,
          "$account_types": :empty,
          "$brand_name": :empty,
          "$site_country": :empty,
          "$site_domain": :empty
        }

  @fields [
    :user_id,
    :session_id,
    :login_status,
    :user_email,
    :ip,
    :browser,
    :app,
    :failure_reason,
    :username,
    :social_sign_on_type,
    :account_types,
    :brand_name,
    :site_country,
    :site_domain
  ]

  @login_statuses [:success, :failure]

  @failure_reasons [
    :account_unknown,
    :account_suspended,
    :account_disabled,
    :wrong_password
  ]

  @social_sign_on_types [
    :facebook,
    :google,
    :linkedin,
    :twitter,
    :yahoo,
    :microsoft,
    :amazon,
    :apple,
    :other
  ]

  @doc """
  Creates a new Login Event for Sift Science

  For more information please refer to the oficial docs:
  https://sift.com/developers/docs/curl/events-api/reserved-events/login

  ## Parameters
    - `login_data`: A map with all the login data to report:
      * `:api_key`: api_key(),
      * `:user_id`: The user's account ID according to your systems. Note that user IDs are case sensitive.
      * `:session_id`: The user's current session ID, used to tie a user's action before and after log in or account
        creation
      * `:login_status`:The success or failure of the login attempt. It can be `:success` or `:failure`
      * `:user_email`: Email of the user that is logging in
      * `:ip`: IP address of the user that is logging in.
      * `:browser`: The user agent of the browser that is logging in.
      * `:app`: The details of the app, os, and device that is logging in.
      * `:failure_reason`: The reason for the failure of the login. Supported values are:
        * `:account_unknown`
        * `:account_suspended`
        * `:account_disabled`
        * `:wrong_password`
      * `:username`: The username entered at the login prompt
      * `:social_sign_on_type`: If the user logged in with a social identify provider, give the name here. Supported
        values are: `:facebook`, `:google`, `:linkedin`, `:twitter`, `:yahoo`, `:microsoft`, `:amazon`, `:apple`, and
        `:other`
      * `:account_types`: Capture the type(s) of the account: `"merchant"` or `"shopper"`, `"regular"` or `"premium"`,
        etc. The array supports multiple types for a single account, e.g. `["merchant", "premium"]`
      * `:brand_name`: Name of the brand of product or service being purchased
      * `:site_country`: Country the company is providing service from. Use ISO-3166 country code.
      * `:site_domain`: Domain being interfaced with. Use fully qualified domain name

  ## Examples

      iex> Siftsciex.Event.Login.create(%{user_id: "jack.shephard", login_status: :success})
      {:ok, %Siftsciex.Event.Login{"$type": "$login", "$user_id": "jack.shephard", "$login_status": "$success"}}

      iex> Siftsciex.Event.Login.create(%{user_id: "jack.shephard", failure_reason: :bad_arg})
      {:error, "invalid failure_reason: bad_arg"}

  """
  @spec create(login_data :: map()) :: {:ok, %__MODULE__{}} | {:error, String.t()}
  def create(login_data) do
    normalized =
      login_data
      |> Map.take(@fields)
      |> Enum.reduce_while(%{}, fn entry, acc ->
        case normalize(entry) do
          {:ok, {key, value}} ->
            {:cont, Map.put(acc, key, value)}

          error ->
            {:halt, error}
        end
      end)

    case normalized do
      %{} = _normalized ->
        {:ok, struct(__MODULE__, normalized)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp normalize({:app, value}), do: {:ok, {mark(:app), App.new(value)}}
  defp normalize({:browser, value}), do: {:ok, {mark(:browser), Browser.new(value)}}

  defp normalize({:login_status, value}) when value in @login_statuses,
    do: {:ok, {mark(:login_status), mark_string(value)}}

  defp normalize({:login_status, value}),
    do: {:error, "invalid login_status: #{value}"}

  defp normalize({:failure_reason, value}) when value in @failure_reasons,
    do: {:ok, {mark(:failure_reason), mark_string(value)}}

  defp normalize({:failure_reason, value}),
    do: {:error, "invalid failure_reason: #{value}"}

  defp normalize({:social_sign_on_type, value}) when value in @social_sign_on_types,
    do: {:ok, {mark(:social_sign_on_type), mark_string(value)}}

  defp normalize({:social_sign_on_type, value}),
    do: {:error, "invalid social_sign_on_type: #{value}"}

  defp normalize({key, value}), do: {:ok, {mark(key), value}}
end
