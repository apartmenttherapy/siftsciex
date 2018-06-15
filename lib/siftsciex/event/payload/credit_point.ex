defmodule Siftsciex.Event.Payload.CreditPoint do
  @moduledoc """
  Represents a [Credit Point](https://siftscience.com/developers/docs/curl/events-api/complex-field-types/credit-point) in Sift Science.
  """

  import Siftsciex

  alias Siftsciex.Event.Payload

  @enforce_keys [:"$amount",:"$credit_point_type"]
  defstruct "$amount": :empty, "$credit_point_type": :empty
  @type t :: %__MODULE__{"$amount": Payload.payload_int,
                         "$credit_point_type": Payload.payload_string}
  @type data :: %{amount: integer,
                  credit_point_type: String.t}

  @doc """
  Creates a new `t:Siftsciex.Event.Payload.CreditPoint.t/0` struct for us in an Event payload.

  ## Parameters

    - `credit_data`: The particulars of the credit in question, there are two *required* attributes
      * `:amount` - The amount or value of the credit
      * `:credit_point_type` - What the credit represents, this typically isn't real money but maybe something like points...

  ## Examples

      iex> CreditPoint.new(%{amount: 30, credit_point_type: "Points"})
      %CreditPoint{"$amount": 30, "$credit_point_type": "Points"}

  """
  @spec new(data) :: __MODULE__.t
  def new(%{amount: _, credit_point_type: _} = credit_data) do
    normalized = Enum.map(credit_data, &normalize/1)

    struct(__MODULE__, normalized)
  end

  defp normalize({:amount, value}), do: {mark(:amount), value}
  defp normalize({:credit_point_type, value}), do: {mark(:credit_point_type), value}
end
