defmodule Siftsciex.Event.Payload.Discount do
  @moduledoc """
  A discount for a Sift Event
  """

  import Siftsciex

  alias Siftsciex.Currency
  alias Siftsciex.Event.Payload

  defstruct "$percentage_off": :empty,
            "$amount": :empty,
            "$currency_code": :empty,
            "$minimum_purchase_amount": :empty
  @type t :: %__MODULE__{"$percentage_off": Payload.payload_float,
                         "$amount": Payload.payload_int,
                         "$currency_code": Payload.payload_string,
                         "$minimum_purchase_amount": Payload.payload_int}
  @type numeric :: integer | float
  @type numeric_key :: :percentage_off | :amount | :minimum_purchase_amount
  @type data :: %{optional(:currency_code) => String.t,
                  optional(numeric_key) => numeric}

  @doc """
  Create a new `Discount` type for a Sift Science Event payload.

  ## Parameters

    - `data`: A map defining the details of the discount, there are four keys which are legal for a discount:
      * `:percentage_off` - A float representing the discount as a percentage.
      * `:amount` - The total amount of the discount, this value will be converted to micros automatically (see `Siftsciex.Currency`).
      * `:currency_code` - The currency in which the discount is being measured.
      * `:minimum_purchase_amount` - The minimum purchase amount before the discount applies.

  ## Examples

      iex> Discount.new(%{percentage_off: 0.3, amount: 3, currency_code: "USD"})
      %Discount{"$percentage_off": 0.3, "$amount": 3000000, "$currency_code": "USD"}

      iex> Discount.new(%{percentage_off: 0.1, currency_code: "USD", amount: 100, minimum_purchase_amount: 50})
      %Discount{"$percentage_off": 0.1, "$currency_code": "USD", "$amount": 100000000, "$minimum_purchase_amount": 50000000}

  """
  @spec new(data) :: __MODULE__.t
  def new(data) do
    normalized =
      data
      |> Enum.map(fn pair -> normalize(pair, data) end)

    struct(%__MODULE__{}, normalized)
  end

  defp normalize({:percentage_off, value}, _), do: {mark(:percentage_off), value}
  defp normalize({:amount, value}, data) do
    {mark(:amount), Currency.as_micros(value, currency_type(data))}
  end
  defp normalize({:currency_code, value}, _), do: {mark(:currency_code), value}
  defp normalize({:minimum_purchase_amount, value}, data) do
    {mark(:minimum_purchase_amount), Currency.as_micros(value, currency_type(data))}
  end

  defp currency_type(data), do: Map.get(data, :currency_code, nil)
end
