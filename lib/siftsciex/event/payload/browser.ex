defmodule Siftsciex.Event.Payload.Browser do
  @moduledoc """
  Represents a browser object in a Sift Event payload
  """

  alias Siftsciex.Event.Payload

  defstruct "$user_agent": :empty
  @type t :: %__MODULE__{"$user_agent": Payload.payload_string}
  @type data :: %{user_agent: String.t}

  @doc """
  Create a new Browser record for a Sift Science Event

  ## Parameters

    - `browser_data`: A map of information about the browser, currently the only supported key is `:user_agent`

  ## Examples

      iex> Browser.new(%{user_agent: "Firefox"})
      %Browser{"$user_agent": "Firefox"}

  """
  @spec new(data) :: __MODULE__.t
  def new(browser_data) do
    %__MODULE__{"$user_agent": browser_data.user_agent()}
  end
end
