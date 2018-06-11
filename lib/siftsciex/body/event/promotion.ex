defmodule Siftsciex.Body.Event.Promotion do
  @moduledoc """
  A Promotion represents just that in Sift Science.  Things like referrals, coupons, free trials etc are considered promotions.
  """

  import Siftsciex

  alias Siftsciex.Body
  alias Siftsciex.Body.Event.{CreditPoint, Discount}

  @enforce_keys [:"$promotion_id"]
  defstruct "$promotion_id": :empty,
            "$status": :empty,
            "$failure_reason": :empty,
            "$description": :empty,
            "$referrer_user_id": :empty,
            "$discount": :empty,
            "$credit_point": :empty
  @type t :: %__MODULE__{"$promotion_id": Body.payload_string,
                         "$status": Body.payload_string,
                         "$failure_reason": Body.payload_string,
                         "$description": Body.payload_string,
                         "$referrer_user_id": Body.payload_string,
                         "$discount": :empty | Discount.t,
                         "$credit_point": :empty | CreditPoint.t}
  @type status :: :success | :failure
  @type string_key :: :promotion_id
                      | :failure_reason
                      | :description
                      | :referrer_user_id
  @type data :: %{optional(string_key) => String.t,
                  optional(:status) => status,
                  optional(:discount) => Discount.data,
                  optional(:credit_point) => CreditPoint.data}

  @doc """
  Creates a new Promotion record for a Sift Science Event.

  ## Parameters

    - `promotion_data`: The data for the promotion being reported to Sift Science, there are a few attributes available.
      * `:promotion_id` - A string idenditying the promotion
      * `:success` - Whether the promotion event indicates success or failure (`:success`, `:failure`)
      * `:failure_reason` - The reason for failure (`String.t`)
      * `:description` - A description of the failure (`String.t`)
      * `:referrer_user_id` - If the promotion had a referrer (`String.t`)
      * `:discount` - Any applicable discount for the promotion (`Siftsciex.Body.Event.Discount.data`)
      * `:credit_point` - Any applicable credit for the promotion (`Siftsciex.Body.Event.CreditPoint.data`)

  ## Examples

      iex> Promotion.new(%{promotion_id: "promo", status: :success})
      %Promotion{"$promotion_id": "promo", "$status": :"$success"}

      iex> Promotion.new(%{promotion_id: "promo", discount: %{percentage_off: 0.25}})
      %Promotion{"$promotion_id": "promo", "$discount": %Siftsciex.Body.Event.Discount{"$percentage_off": 0.25}}

      iex> Promotion.new(%{promotion_id: "promo", credit_point: %{amount: 33, credit_point_type: "Things"}})
      %Promotion{"$promotion_id": "promo", "$credit_point": %Siftsciex.Body.Event.CreditPoint{"$amount": 33, "$credit_point_type": "Things"}}

      iex> Promotion.new(%{promotion_id: "promo", credit_point: %{amount: 1, credit_point_type: "Thing"}, discount: %{percentage_off: 0.1}})
      %Promotion{"$promotion_id": "promo", "$credit_point": %Siftsciex.Body.Event.CreditPoint{"$amount": 1, "$credit_point_type": "Thing"}, "$discount": %Siftsciex.Body.Event.Discount{"$percentage_off": 0.1}}

  """
  @spec new(data) :: __MODULE__.t
  def new(promotion_data) do
    normalized = Enum.map(promotion_data, &normalize/1)

    struct(__MODULE__, normalized)
  end

  defp normalize({:promotion_id, value}), do: {mark(:promotion_id), value}
  defp normalize({:status, value}), do: {mark(:status), mark(value)}
  defp normalize({:failure_reason, value}), do: {mark(:failure_reason), value}
  defp normalize({:description, value}), do: {mark(:description), value}
  defp normalize({:referrer_user_id, value}), do: {mark(:referrer_user_id), value}
  defp normalize({:discount, values}), do: {mark(:discount), Discount.new(values)}
  defp normalize({:credit_point, values}) do
    {mark(:credit_point), CreditPoint.new(values)}
  end
end
