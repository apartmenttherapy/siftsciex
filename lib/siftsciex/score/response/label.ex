defmodule Siftsciex.Score.Response.Label do
  @moduledoc """
  Represents a label in a Score response (`t:Siftsciex.Score.Response.t/0`) from Sift
  """

  alias Siftsciex.Score

  defstruct type: :empty, is_bad: :empty, time: :empty, description: :empty
  @type t :: %__MODULE__{type: :empty | Score.abuse_type,
                         is_bad: :empty | boolean,
                         time: :empty | DateTime.t,
                         description: :empty | String.t}

  @doc """
  Creates a new Label record from a Sift Science Score response

  ## Parameters

    - `label_data`: The data for the label (as a Map.t)

  ## Examples

      iex> Label.new(%{payment_abuse: %{is_bad: true, time: 1529011047, description: "Fake card"}})
      %Label{type: :payment_abuse, is_bad: true, time: #DateTime<2018-06-14 21:17:27Z>, description: "Fake card"}

  """
  @spec new(map) :: __MODULE__.t
  def new(label_data) do
    [{type, data}] = Map.to_list(label_data)

    %__MODULE__{type: type}
    |> struct(data)
    |> convert_time()
  end

  defp convert_time(record) do
    {:ok, date_time} = DateTime.from_unix(record.time())

    struct(record, time: date_time)
  end
end
