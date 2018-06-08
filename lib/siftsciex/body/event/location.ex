defmodule Siftsciex.Body.Event.Location do
  @moduledoc """
  A location for a Sift Science Event
  """

  alias Siftsciex.Body

  defstruct "$city": :empty, "$region": :empty, "$country": :empty, "$zipcode": :empty
  @type t :: %__MODULE__{"$city": Body.payload_string,
                         "$region": Body.payload_string,
                         "$country": Body.payload_string,
                         "$zipcode": Body.payload_string}

  @type attribute :: :city | :region | :country | :zipcode
  @type data :: %{optional(attribute) => String.t}

  @doc """
  Creates a new `__MODULE__.t` struct for use in a Sift Science Event

  ## Parameters

    - `data`: The location data (`__MODULE__.data`)

  ## Examples

      iex> Location.new(%{city: "Paris", country: "France"})
      %Location{"$city": "Paris", "$country": "France"}

  """
  @spec new(data) :: __MODULE__.t
  def new(data) do
    normalized = Enum.map(data, &normalize/1)

    struct(%__MODULE__{}, normalized)
  end

  defp normalize({:city, value}), do: {String.to_atom("$city"), value}
  defp normalize({:region, value}), do: {String.to_atom("$region"), value}
  defp normalize({:country, value}), do: {String.to_atom("$country"), value}
  defp normalize({:zipcode, value}), do: {String.to_atom("$zipcode"), value}
end
