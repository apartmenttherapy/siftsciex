defmodule Siftsciex.Score.Response.Score do
  @moduledoc """
  Represents the `scores` items in a Score response (`t:Siftsciex.Score.Response.t/0`) from Sift
  """

  alias Siftsciex.Score
  alias Siftsciex.Score.Response.Reason

  defstruct type: :empty, score: :empty, reasons: :empty
  @type t :: %__MODULE__{type: :empty | Score.abuse_type,
                         score: :empty | float,
                         reasons: :empty | [Reason.t]}
  @type data :: %{required(Score.abuse_type) => %{score: float, reasons: [map]}}

  @doc """
  Converts a map to a new `t:Siftsciex.Score.Response.Score.t/0` record.

  ## Parameters

    - `data`: A map or list of maps that should be converted to `t:Siftsciex.Score.Response.Score.t/0` records

  ## Examples

      iex> Score.new(%{payment_abuse: %{score: 0.5, reasons: [%{name: "Bad", value: "thing", details: %{"user_id" => "bob"}}]}})
      %Score{type: :payment_abuse, score: 0.5, reasons: [%Siftsciex.Score.Response.Reason{name: "Bad", value: "thing", details: %{"user_id" => "bob"}}]}

      iex> Score.new([%{payment_abuse: %{score: 0.5, reasons: [%{name: "Bad", value: "thing"}]}}, %{promotion_abuse: %{score: 0.3}}])
      [%Score{type: :payment_abuse, score: 0.5, reasons: [%Siftsciex.Score.Response.Reason{name: "Bad", value: "thing"}]}, %Score{type: :promotion_abuse, score: 0.3}]

  """
  @spec new(data | [data]) :: [__MODULE__.t]
  def new(data) when is_list(data) do
    Enum.map(data, &new/1)
  end
  def new(data) do
    [{type, data}] = Map.to_list(data)

    %__MODULE__{type: type}
    |> struct(data)
    |> process_reasons(data)
  end

  defp process_reasons(record, %{reasons: reasons}) do
    struct(record, reasons: Reason.new(reasons))
  end
  defp process_reasons(record, _), do: record
end
