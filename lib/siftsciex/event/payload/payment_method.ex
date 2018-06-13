defmodule Siftsciex.Event.Payload.PaymentMethod do
  @moduledoc """
  This module will construct and return a payment method struct of the specified type.
  """

  require Logger
  import Siftsciex

  alias Siftsciex.Event.Payload
  alias Siftsciex.Validation.Gateway

  defstruct "$payment_type": :empty,
            "$payment_gateway": :empty,
            "$card_bin": :empty,
            "$card_last4": :empty,
            "$avs_result_code": :empty,
            "$cvv_result_code": :empty,
            "$verification_status": :empty,
            "$routing_number": :empty,
            "$decline_reason_code": :empty,
            "$paypal_payer_id": :empty,
            "$paypal_payer_email": :empty,
            "$paypal_payer_status": :empty,
            "$paypal_address_status": :empty,
            "$paypal_protection_eligibility": :empty,
            "$paypal_payment_status": :empty,
            "$stripe_cvc_check": :empty,
            "$stripe_address_line1_check": :empty,
            "$stripe_address_line2_check": :empty,
            "$stripe_address_zip_check": :empty,
            "$stripe_funding": :empty,
            "$stripe_brand": :empty
  @type t :: %__MODULE__{"$payment_type": Payload.payload_string,
                         "$payment_gateway": Payload.payload_string,
                         "$card_bin": Payload.payload_string,
                         "$card_last4": Payload.payload_string,
                         "$avs_result_code": Payload.payload_string,
                         "$cvv_result_code": Payload.payload_string,
                         "$verification_status": Payload.payload_string,
                         "$routing_number": Payload.payload_string,
                         "$decline_reason_code": Payload.payload_string,
                         "$paypal_payer_id": Payload.payload_string,
                         "$paypal_payer_email": Payload.payload_string,
                         "$paypal_payer_status": Payload.payload_string,
                         "$paypal_address_status": Payload.payload_string,
                         "$paypal_protection_eligibility": Payload.payload_string,
                         "$paypal_payment_status": Payload.payload_string,
                         "$stripe_cvc_check": Payload.payload_string,
                         "$stripe_address_line1_check": Payload.payload_string,
                         "$stripe_address_line2_check": Payload.payload_string,
                         "$stripe_address_zip_check": Payload.payload_string,
                         "$stripe_funding": Payload.payload_string,
                         "$stripe_brand": Payload.payload_string}

  @type source :: :cash
                  | :check
                  | :credit_card
                  | :crypto_currency
                  | :digital_wallet
                  | :electronic_fund_transfer
                  | :financing
                  | :gift_card
                  | :invoice
                  | :in_app_purchase
                  | :money_order
                  | :points
                  | :store_credit
                  | :third_party_processor

  @type attribute :: :payment_gateway
                     | :card_bin
                     | :card_last4
                     | :avs_result_code
                     | :cvv_result_code
                     | :verification_status
                     | :routing_number
                     | :decline_reason_code
                     | :paypal_payer_id
                     | :paypal_payer_email
                     | :paypal_payer_status
                     | :paypal_address_status
                     | :paypal_protection_eligibility
                     | :paypal_payment_status
                     | :stripe_cvc_check
                     | :stripe_address_line1_check
                     | :stripe_address_line2_check
                     | :stripe_address_zip_check
                     | :stripe_funding
                     | :stripe_brand
  @type data :: %{required(:payment_type) => source,
                  optional(attribute) => String.t}

  @doc """
  Creates a new Payment Method object for Sift Science

  ## Parameters

    - `data`: The general data about the payment method, multiple payment methods may be passed together, there are several available attributes.
      * `:payment_gateway`
      * `:card_bin` - The first 6 digits of the card number
      * `:card_last4`
      * `:avs_result_code`
      * `:cvv_result_code`
      * `:verification_status`
      * `:routing_number`
      * `:decline_reason_code`
      * `:paypal_payer_id`
      * `:paypal_payer_email`
      * `:paypal_payer_status`
      * `:paypal_address_status`
      * `:paypal_protection_eligibility`
      * `:paypal_payment_status`
      * `:stripe_cvc_check`
      * `:stripe_address_line1_check`
      * `:stripe_address_line2_check`
      * `:stripe_address_zip_check`
      * `:stripe_funding`
      * `:stripe_brand`

  ## Examples

      iex> PaymentMethod.new(%{payment_type: :credit_card})
      %PaymentMethod{"$payment_type": "$credit_card"}

      iex> PaymentMethod.new(%{payment_type: :credit_card, payment_gateway: "stripe"})
      %PaymentMethod{"$payment_type": "$credit_card", "$payment_gateway": "$stripe"}

      iex> PaymentMethod.new([%{payment_type: :credit_card}, %{payment_type: :credit_card, payment_gateway: "stripe"}])
      [%PaymentMethod{"$payment_type": "$credit_card"}, %PaymentMethod{"$payment_type": "$credit_card", "$payment_gateway": "$stripe"}]

      iex> PaymentMethod.new(%{payment_type: :credit_card, payment_gateway: "bogus"})
      :empty

  """
  @spec new(data | [data]) :: __MODULE__.t | [__MODULE__.t] | :empty
  def new(methods) when is_list(methods) do
    methods
    |> Enum.map(&(new(&1)))
    |> Enum.reject(&(&1 == :empty))
  end
  # Start individual processing
  def new(%{payment_gateway: nil} = data) do
    data = Map.delete(data, :payment_gateway)
    record = Enum.map(data, &normalize/1)

    struct(%__MODULE__{}, record)
  end
  def new(%{payment_gateway: gateway} = data) do
    gateway
    |> Gateway.supported?()
    |> case do
         true ->
           normalized = Enum.map(data, &normalize/1)
           struct(%__MODULE__{}, normalized)
         false ->
           Logger.error("Invalid Gateway (#{gateway}) given for Payment Method: #{Kernel.inspect(data)}")
           :empty
       end
  end
  def new(data) do
    record = Enum.map(data, &normalize/1)

    struct(%__MODULE__{}, record)
  end

  defp normalize({:payment_type, value}), do: {mark(:payment_type), mark_string(value)}
  defp normalize({:card_bin, value}), do: {mark(:card_bin), value}
  defp normalize({:card_last4, value}), do: {mark(:card_last4), value}
  defp normalize({:avs_result_code, value}), do: {mark(:avs_result_code), value}
  defp normalize({:cvv_result_code, value}), do: {mark(:cvv_result_code), value}
  defp normalize({:verification_status, value}), do: {mark(:verification_status), value}
  defp normalize({:routing_number, value}), do: {mark(:routing_number), value}
  defp normalize({:decline_reason_code, value}), do: {mark(:decline_reason_code), value}
  defp normalize({:paypal_payer_id, value}), do: {mark(:paypay_payer_id), value}
  defp normalize({:paypal_payer_email, value}), do: {mark(:paypay_payer_email), value}
  defp normalize({:paypay_payer_status, value}), do: {mark(:paypay_payer_status), value}
  defp normalize({:paypal_address_status, value}) do
    {mark(:paypal_address_status), value}
  end
  defp normalize({:paypal_protection_eligibility, value}) do
    {mark(:paypal_protection_eligibility), value}
  end
  defp normalize({:paypal_payment_status, value}) do
    {mark(:paypal_payment_status), value}
  end
  defp normalize({:stripe_cvc_check, value}), do: {mark(:stripe_cvc_check), value}
  defp normalize({:stripe_address_line1_check, value}) do
    {mark(:stripe_address_line1_check), value}
  end
  defp normalize({:stripe_address_line2_check, value}) do
    {mark(:stripe_address_line2_check), value}
  end
  defp normalize({:stripe_address_zip_check, value}) do
    {mark(:stripe_address_zip_check), value}
  end
  defp normalize({:stripe_funding, value}), do: {mark(:stripe_funding), value}
  defp normalize({:stripe_brand, value}), do: {mark(:stripe_brand), value}
  defp normalize({:payment_gateway, value}) do
    {mark(:payment_gateway), mark_string(value)}
  end
end
