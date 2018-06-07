defmodule Siftsciex.Body.Event.Root do
  @moduledoc false

  alias Siftsciex.Body

  defstruct "$type": :empty,
            "$api_key": Application.get_env(:siftsciex, :api_key),
            "$user_id": :empty,
            "$content_id": :empty,
            "$session_id": :empty,
            "$status": :empty,
            "$ip": :empty
  @type t :: %__MODULE__{"$type": Body.payload_string,
                         "$api_key": String.t,
                         "$user_id": Body.payload_string,
                         "$content_id": Body.payload_string,
                         "$session_id": Body.payload_string,
                         "$status": Body.payload_string,
                         "$ip": Body.payload_string}

  @doc """
  Builds a new body struct which is ready for the payload to be injected.

  ## Parameters

    - `root_data`: A map or list containing the data to be used for the root of the body

  ## Examples

      iex> Root.new(%{type: "test", user_id: "tester", content_id: "record_x", ip: "123.213.231.132"})
      %Root{"$type": "test", "$user_id": "tester", "$content_id": "record_x", "$ip": "123.213.231.132"}

      iex> Root.new(type: "test", user_id: "tester", content_id: "record_y", ip: "123.213.231.132")
      %Root{"$type": "test", "$user_id": "tester", "$content_id": "record_y", "$ip": "123.213.231.132"}

  """
  @spec new(list | map) :: __MODULE__.t
  def new(root_data) when is_map(root_data) do
    root_data
    |> Map.to_list()
    |> new()
  end
  def new(root_data) when is_list(root_data) do
    mapped =
      root_data
      |> Enum.map(fn {key, value} ->
           {convert_key(key), value}
         end)

    struct(%__MODULE__{}, mapped)
  end

  defp convert_key(key), do: "$#{key}" |> String.to_atom()
end
