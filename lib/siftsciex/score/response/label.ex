defmodule Siftsciex.Score.Response.Label do
  @moduledoc """
  Represents a label in a Score response (`t:Siftsciex.Score.Response.t/0`) from Sift
  """

  defstruct is_bad: :empty, time: :empty, description: :empty

  @type abuse_type :: :payment_abuse | :account_abuse | :content_abuse | :promotion_abuse
  @type label :: %__MODULE__{
          is_bad: :empty | boolean,
          time: :empty | DateTime.t(),
          description: :empty | String.t()
        }

  @type t :: %{abuse_type => label}

  @doc """
  Creates a new Label record from a Sift Science Score response

  ## Parameters

    - `label_data`: The data for the label (as a Map.t)

  ## Examples

      iex> Label.new(%{payment_abuse: %{is_bad: true, time: 1529011047, description: "Fake card"}})
      %{payment_abuse: %Label{is_bad: true, time: #DateTime<2018-06-14 21:17:27Z>, description: "Fake card"}

  """
  @spec new(map) :: t
  def new(label_data) do
    label_data
    |> Map.to_list()
    |> Map.new(fn {type, data} ->
      parsed =
        %__MODULE__{}
        |> struct(data)
        |> convert_time()

      {type, parsed}
    end)
  end

  defp convert_time(record) do
    {:ok, date_time} = DateTime.from_unix(record.time())

    struct(record, time: date_time)
  end
end
