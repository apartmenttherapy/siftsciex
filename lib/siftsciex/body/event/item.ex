defmodule Siftsciex.Body.Event.Item do
  @moduledocc """

  """

  alias Siftsciex.Body
  alias Siftsciex.Currency

  defstruct "$item_id": :empty,
            "$product_title": :empty,
            "$price": 0,
            "$currency_code": :empty,
            "$upc": :empty,
            "$sku": :empty,
            "$brand": :empty,
            "$manufacturer": :empty,
            "$category": :empty,
            "$tags": [],
            "$color": :empty,
            "$quantity": 1
  @type t :: %__MODULE__{"$item_id": Base.payload_string,
                         "$product_title": Base.payload_string,
                         "$price": integer,
                         "$currency_code": Base.payload_string,
                         "$upc": Base.payload_string,
                         "$sku": Base.payload_string,
                         "$brand": Base.payload_string,
                         "$manufacturer": Base.payload_string,
                         "$category": Base.payload_string,
                         "$tags": [String.t],
                         "$color": Base.payload_string,
                         "$quantity": integer}
  @type string_keys :: :item_id
                       | :product_title
                       | :currency_code
                       | :upc
                       | :sku
                       | :brand
                       | :manufacturer
                       | :category
                       | :color
  @type int_keys :: :price | :quantity
  @type list_keys :: :tags
  @type data :: %{optional(string_keys) => String.t,
                  optional(int_keys) => integer,
                  optional(list_keys) => [String.t]}

  @doc """
  Creates a `__MODULE__.t` struct for a Sift Science Event payload.

  When creating a new `Item` the price will be converted based on the `:currency` config.  For example if your currency config is set to `:base` and you are using "USD" then a price of 500 (5 dollars) will be converted to `5000000`, this is because Sift Science expects the micros value relative to the base unit for the currency.  This conversion is handled automatically for you.

  ## Parameters

    - `data`: The item details to be sent to Sift Science (`__MODULE__.data`)

  ## Examples

      iex> # Assuming :currency_unit is set to :base
      iex> Item.new(%{item_id: "8", product_title: "Title", currency_code: "USD", price: 30, quantity: 1})
      %Item{"$item_id": "8", "$product_title": "Title", "$currency_code": "USD", "$price": 30000000, "$quantity": 1}

      iex> Item.new(%{item_id: "8", tags: ["table", "dining"]})
      %Item{"$item_id": "8", "$tags": ["table", "dining"]}

  """
  @spec new(data) :: __MODULE__.t
  def new(data) do
    normalized =
      data
      |> convert_price()
      |> Enum.map(&normalize/1)

    struct(%__MODULE__{}, normalized)
  end

  defp normalize({:item_id, value}), do: {String.to_atom("$item_id"), value}
  defp normalize({:product_title, value}), do: {String.to_atom("$product_title"), value}
  defp normalize({:currency_code, value}), do: {String.to_atom("$currency_code"), value}
  defp normalize({:upc, value}), do: {String.to_atom("$upc"), value}
  defp normalize({:sku, value}), do: {String.to_atom("$sku"), value}
  defp normalize({:brand, value}), do: {String.to_atom("$brand"), value}
  defp normalize({:manufacturer, value}), do: {String.to_atom("$manufacturer"), value}
  defp normalize({:category, value}), do: {String.to_atom("$category"), value}
  defp normalize({:color, value}), do: {String.to_atom("$color"), value}
  defp normalize({:quantity, value}), do: {String.to_atom("$quantity"), value}
  defp normalize({:tags, values}), do: {String.to_atom("$tags"), values}
  defp normalize({:price, value}), do: {String.to_atom("$price"), value}

  defp convert_price(%{price: price} = data) do
    data
    |> Map.put(:price, Currency.as_micros(price, data.currency_code()))
  end
  defp convert_price(data), do: data
end
