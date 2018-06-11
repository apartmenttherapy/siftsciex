defmodule Siftsciex.Body.Event.App do
  @moduledoc """
  A Sift Science [App](https://siftscience.com/developers/docs/curl/events-api/complex-field-types/app) type for the Event API.
  """

  import Siftsciex

  alias Siftsciex.Body

  defstruct "$os": :empty,
            "$os_version": :empty,
            "$device_manufacturer": :empty,
            "$device_model": :empty,
            "$device_unique_id": :empty,
            "$app_name": :empty,
            "$app_version": :empty
  @type t :: %__MODULE__{"$os": Body.payload_string,
                         "$os_version": Body.payload_string,
                         "$device_manufacturer": Body.payload_string,
                         "$device_model": Body.payload_string,
                         "$device_unique_id": Body.payload_string,
                         "$app_name": Body.payload_string,
                         "$app_version": Body.payload_string}
  @type attribute :: :os
                     | :os_version
                     | :device_manufacturer
                     | :device_model
                     | :device_unique_id
                     | :app_name
                     | :app_version
  @type data :: %{optional(attribute) => String.t}

  @doc """
  Creates a new `App` object for a Sift Science Event.

  ## Parameters

    - `app_data`: The data for the application context which is being reported, there are several available attributes:
      * `:os`
      * `:os_version`
      * `:device_manufacturer`
      * `:device_model`
      * `:device_unique_id`
      * `:app_name`
      * `:app_version`

  ## Examples

      iex> App.new(%{os: "iOS", os_version: "10.3", app_name: "Test"})
      %App{"$os": "iOS", "$os_version": "10.3", "$app_name": "Test"}

  """
  @spec new(data) :: __MODULE__.t
  def new(app_data) do
    normalized = Enum.map(app_data, &normalize/1)

    struct(__MODULE__, normalized)
  end

  defp normalize({:os, value}), do: {mark(:os), value}
  defp normalize({:os_version, value}), do: {mark(:os_version), value}
  defp normalize({:device_manufacturer, value}), do: {mark(:device_manufacturer), value}
  defp normalize({:device_model, value}), do: {mark(:device_model), value}
  defp normalize({:device_unique_id, value}), do: {mark(:device_unique_id), value}
  defp normalize({:app_name, value}), do: {mark(:app_name), value}
  defp normalize({:app_version, value}), do: {mark(:app_version), value}
end
