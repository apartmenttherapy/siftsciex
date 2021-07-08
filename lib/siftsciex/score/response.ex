defmodule Siftsciex.Score.Response do
  @moduledoc """
  Represents a Score API response
  """

  require Logger

  alias Siftsciex.Score.Response.{Score, Label, WorkflowStatus}

  defstruct status: :empty,
            error_message: :empty,
            user_id: :empty,
            scores: :empty,
            latest_labels: :empty,
            workflow_statuses: :empty

  @type t :: %__MODULE__{status: :empty | integer,
                         error_message: :empty | String.t,
                         user_id: :empty | String.t,
                         scores: :empty | [Score.t],
                         latest_labels: :empty | [Label.t],
                         workflow_statuses: :empty | [WorkflowStatus.t]}

  @doc """
  Processes a response body and converts it into a `t:Siftsciex.Score.Response.t/0` struct.

  ## Parameters

    - `body`: A `String.t` representation of a Sift Science Score Response

  ## Examples

      iex> Response.process("{\\"status\\":0,\\"error_message\\":\\"OK\\",\\"user_id\\":\\"bob\\",\\"scores\\":{\\"payment_abuse\\":{\\"score\\":0.3}}}")
      %Response{status: 0, error_message: "OK", user_id: "bob", scores: [%Siftsciex.Score.Response.Score{type: :payment_abuse, score: 0.3}]}

  """
  @spec process(String.t | map) :: __MODULE__.t
  def process(body) when is_binary(body) do
    body
    |> Poison.decode(keys: :atoms)
    |> case do
         {:ok, response} ->
           process(response)
         {:error, reason} ->
           Logger.error("Invalid (#{inspect(reason)}) JSON response from Sift Science: #{inspect(body)}")
           %__MODULE__{}
       end
  end

  def process(body) do
    __MODULE__
    |> struct(body)
    |> convert_nested()
  end

  defp convert_nested(record) do
    record
    |> convert_scores(record.scores())
    |> convert_labels(record.latest_labels())
    |> convert_workflow_statuses(record.workflow_statuses())
  end

  defp convert_scores(record, :empty), do: record
  defp convert_scores(record, scores) when map_size(scores) == 0 do
    struct(record, scores: :empty)
  end
  defp convert_scores(record, scores) do
    struct(record, scores: Score.new(scores))
  end

  defp convert_labels(record, :empty), do: record
  defp convert_labels(record, labels) when map_size(labels) == 0 do
    struct(record, latest_labels: :empty)
  end
  defp convert_labels(record, labels) do
    struct(record, latest_labels: Label.new(labels))
  end

  defp convert_workflow_statuses(record, :empty), do: record
  defp convert_workflow_statuses(record, workflow_statuses) do
    struct(record, workflow_statuses: WorkflowStatus.new(workflow_statuses))
  end
end
