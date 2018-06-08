defmodule Siftsciex.Body.Event.Address do
  @moduledoc """
  Internal representation and "constructor" for a Sift Science address
  """

  alias Siftsciex.Body

  defstruct "$name": :empty, "$phone": :empty, "$city": :empty, "$region": :empty, "$country": :empty, "$zipcode": :empty
  @type t :: %__MODULE__{"$name": Base.payload_string,
                         "$phone": Base.payload_string,
                         "$city": Base.payload_string,
                         "$region": Base.payload_string,
                         "$country": Base.payload_string,
                         "$zipcode": Base.payload_string}

  @type attributes :: :name | :phone | :city | :region | :country | :zipcode
  @type data :: %{required(attributes) => String.t} # Maybe optional instead of required?

  @doc """
  Creates a new `__MODULE__.t` struct from `__MODULE__.data`

  ## Parameters

    - `data`: The data for the address (`__MODULE__.data`)

  ## Examples

      iex> Address.new(%{name: "Bob", city: nil, country: "US"})
      %Address{"$name": "Bob", "$phone": :empty, "$city": nil, "$region": :empty, "$country": "US", "$zipcode": :empty}

  """
  @spec new(data) :: __MODULE__.t
  def new(data) do
    normalized = Enum.map(data, &normalize/1)

    struct(%__MODULE__{}, normalized)
  end

  def normalize({:name, value}), do: {String.to_atom("$name"), value}
  def normalize({:phone, value}), do: {String.to_atom("$phone"), value}
  def normalize({:city, value}), do: {String.to_atom("$city"), value}
  def normalize({:region, value}), do: {String.to_atom("$region"), value}
  def normalize({:country, value}), do: {String.to_atom("$country"), value}
  def normalize({:zipcode, value}), do: {String.to_atom("$zipcode"), value}
end
