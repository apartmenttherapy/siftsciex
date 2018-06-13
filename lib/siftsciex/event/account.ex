defmodule Siftsciex.Event.Account do
  @moduledoc """

  """

  import Siftsciex

  alias Siftsciex.Event.Payload
  alias Siftsciex.Event.Payload.{Address, PaymentMethod, Promotion}

  defstruct "$user_email": :empty,
            "$name": :empty,
            "$phone": :empty,
            "$referrer_user_id": :empty,
            "$payment_methods": :empty,
            "$billing_address": :empty,
            "$shipping_address": :empty,
            "$promotions": :empty,
            "$social_sign_on_type": :empty
  @type t :: %__MODULE__{"$user_email": Payload.payload_string,
                         "$name": Payload.payload_string,
                         "$phone": Payload.payload_string,
                         "$referrer_user_id": Payload.payload_string,
                         "$payment_methods": :empty | [PaymentMethod.t],
                         "$billing_address": :empty | Address.t,
                         "$shipping_address": :empty | Address.t,
                         "$promotions": :empty | [Promotion.t],
                         "$social_sign_on_type": Payload.payload_string}
  @type string_attr :: :user_email
                       | :name
                       | :phone
                       | :referrer_user_id
                       | :social_sign_on_type
  @type data :: %{optional(string_attr) => String.t,
                  optional(:payment_methods) => [PaymentMethod.data],
                  optional(:billing_address) => Address.data,
                  optional(:shipping_address) => Address.data,
                  optional(:promotions) => [Promotion.data]}

  @doc """
  Creates a new Account Event for Sift Science, this is not a complete event but will generate all the data specific to the account.

  ## Parameters

    - `account_data`: The data pertinent to the account that has been created, there are several fields available.
      * `:user_email` - The email address for the account
      * `:name` - The name of the user
      * `:phone` - The phone number given with the account (if any)
      * `:referrer_user_id` - The internal user_id of any referrer for this signup
      * `:social_sign_on_type` - If the account is tied to a social account this should be the provider (`"facebook"`, `"twitter"`, `"google"`, `"linkedin"`, `"yahoo"`, `"other"`)
      * `:payment_methods` - A list of any payment methods used/given during signup (`Siftsciex.Event.Payload.PaymentMethod.data`)
      * `:billing_address` - The billing address for the account, if given (`Siftsciex.Event.Payload.Address.data`)
      * `:shipping_address` - The shipping address provided for the account, if given (`Siftsciex.Event.Payload.Address.data`)
      * `:promotions` - A list of any pormotions (`Siftsciex.Event.Payload.Promotion.data`) used in conjunction with the signup

  ## Examples

      iex> Account.new(%{user_email: "bob@example.com"})
      %Account{"$user_email": "bob@example.com"}

      iex> Account.new(%{user_email: "bob@example.com", payment_methods: [%{payment_type: :cash}]})
      %Account{"$user_email": "bob@example.com", "$payment_methods": [%PaymentMethod{"$payment_type": "$cash"}]}

      iex> Account.new(%{user_email: "bob@example.com", billing_address: %{name: "Bob", zipcode: "87102"}})
      %Account{"$user_email": "bob@example.com", "$billing_address": %Address{"$name": "Bob", "$zipcode": "87102"}}

      iex> Account.new(%{user_email: "bob@example.com", promotions: [%{promotion_id: "promo"}]})
      %Account{"$user_email": "bob@example.com", "$promotions": [%Promotion{"$promotion_id": "promo"}]}

  """
  @spec new(data) :: __MODULE__.t
  def new(account_data) do
    normalized = Enum.map(account_data, &normalize/1)

    struct(__MODULE__, normalized)
  end

  defp normalize({:user_email, value}), do: {mark(:user_email), value}
  defp normalize({:name, value}), do: {mark(:name), value}
  defp normalize({:phone, value}), do: {mark(:phone), value}
  defp normalize({:referrer_user_id, value}), do: {mark(:referrer_user_id), value}
  defp normalize({:promotions, value}), do: {mark(:promotions), Promotion.new(value)}
  defp normalize({:payment_methods, value}) do
    {mark(:payment_methods), PaymentMethod.new(value)}
  end
  defp normalize({:billing_address, value}) do
    {mark(:billing_address), Address.new(value)}
  end
  defp normalize({:shipping_address, value}) do
    {mark(:shipping_address), Address.new(value)}
  end
end
