defmodule Siftsciex.Event.Payload.Address do
  @moduledoc """
  Internal representation and "constructor" for a Sift Science address
  """

  alias Siftsciex.Event.Payload

  defstruct "$name": :empty,
            "$address_1": :empty,
            "$address_2": :empty,
            "$phone": :empty,
            "$city": :empty,
            "$region": :empty,
            "$country": :empty,
            "$zipcode": :empty
  @type t :: %__MODULE__{"$name": Payload.payload_string,
                         "$address_1": Payload.payload_string,
                         "$address_2": Payload.payload_string,
                         "$phone": Payload.payload_string,
                         "$city": Payload.payload_string,
                         "$region": Payload.payload_string,
                         "$country": Payload.payload_string,
                         "$zipcode": Payload.payload_string}

  @type attributes :: :name
                      | :address_1
                      | :address_2
                      | :phone
                      | :city
                      | :region
                      | :country
                      | :zipcode
  @type data :: %{optional(attributes) => String.t}

  @doc """
  Creates a new `__MODULE__.t` struct from `__MODULE__.data`

  ## Parameters

    - `data`: The data for the address (`__MODULE__.data`)

  ## Examples

      iex> Address.new(%{name: "Bob", city: nil, country: "US"})
      %Address{"$name": "Bob", "$phone": :empty, "$city": nil, "$region": :empty, "$country": "US", "$zipcode": :empty}

      iex> Address.new([%{name: "Walt", city: "Albuquerque"}, %{name: "Bob", region: "FL"}])
      [%Address{"$name": "Walt", "$city": "Albuquerque"}, %Address{"$name": "Bob", "$region": "FL"}]

  """
  @spec new(data) :: __MODULE__.t
  def new(data) when is_list(data) do
    Enum.map(data, &(new(&1)))
  end
  def new(data) do
    normalized = Enum.map(data, &normalize/1)

    struct(%__MODULE__{}, normalized)
  end

  def normalize({:name, value}), do: {String.to_atom("$name"), value}
  def normalize({:address_1, value}), do: {String.to_atom("$address_1"), value}
  def normalize({:address_2, value}), do: {String.to_atom("$address_2"), value}
  def normalize({:phone, value}), do: {String.to_atom("$phone"), value}
  def normalize({:city, value}), do: {String.to_atom("$city"), value}
  def normalize({:region, value}), do: {String.to_atom("$region"), value}
  def normalize({:country, value}), do: {String.to_atom("$country"), value}
  def normalize({:zipcode, value}), do: {String.to_atom("$zipcode"), value}
end
