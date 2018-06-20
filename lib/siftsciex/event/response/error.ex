defmodule Siftsciex.Event.Response.Error do
  @moduledoc false

  alias Siftsciex.Event.Response

  @type value :: :unavailable
                 | :processing_timeout
                 | :processing_error
                 | :invalid_api_key
                 | :invalid_name
                 | :invalid_value
                 | :missing_field
                 | :invalid_json
                 | :invalid_http_body
                 | :rate_limited
                 | :invalid_api_version
                 | :invalid_reserved_field
                 | :none
                 | :unknown

  @error_map %{
    -4 => :unavailable,
    -3 => :processing_timeout,
    -2 => :processing_error,
    -1 => :processing_error,
    51 => :invalid_api_key,
    52 => :invalid_name,
    53 => :invalid_value,
    55 => :missing_field,
    56 => :invalid_json,
    57 => :invalid_http_body,
    60 => :rate_limited,
    104 => :invalid_api_version,
    105 => :invalid_reserved_field
  }

  @doc """
  Translates an error response code to a simple atom representation.

  ## Parameters

    - `response`: A `t:Siftsciex.Event.Response.t/0` record for which the error should be "translated"

  ## Examples

      iex> Error.error(response)
      :rate_limited

  """
  @spec error(Response.t) :: value
  def error(response) do
    response.status()
    |> case do
         :empty ->
           :unknown
         status ->
           Map.get(@error_map, response.status(), :none)
       end
  end
end
