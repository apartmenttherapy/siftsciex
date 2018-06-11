defmodule Siftsciex.Event do
  @moduledoc """
  The Event module is used for registering events with SiftScience.
  """

  alias Siftsciex.Validation

  @type error_map :: %{required(String.t) => String.t}

  @doc """
  Registers an event with Sift Science, this function takes the event type along with a map containing the data for the event.  It returns `:ok` if the event is registered, `{:error, :badarg, %{errors: __MODULE__.error_map}` if a reqired field is missing, or `{:error, :trasport, reason}` if the connection to Sift Science fails for some reason.

  ## Parameters

    - `event_type`: This is the type of event which is being registered, this is used to construct the request as well as validate the event data
    - `data`: This is the event data, the event data should include all the specific values for the record you are reporting on

  ## Examples

      iex> Event.register("create_content.message", %{user_id: "bob", content_id: "2", status: :active, ip: "123.231.132.0", data: message})
      :ok

  """
  @spec register(String.t, map) :: :ok
                                   | {:error, :transport, map}
                                   | {:error, :badarg, error_map}
  def register(type, data) do
    type
    |> Validation.validate(data)
    |> case do
         {:ok, payload} ->
           post(payload)
         {:error, errors} ->
           {:error, :badarg, errors}
       end
  end

  def post(payload) do
    #HTTPoison.post(event_url(), payload)
  end
end
