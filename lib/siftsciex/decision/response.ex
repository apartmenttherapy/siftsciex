defmodule Siftsciex.Decision.Response do
  @moduledoc """
  Represents a Decision API response
  """

  require Logger

  defstruct decisions: :empty
  @type t :: %__MODULE__{decisions: :empty | [Decision.t]}

  @doc """
  Processes a response body and converts it into a `t:Siftsciex.Decision.Response.t/0` struct.

  ## Parameters

    - `body`: A `String.t` representation of a Sift Science Decision Response

  ## Examples
      iex> Response.process("{\\"decisions\\":{\\"payment_abuse\\": {\\"decision\\": {\\"id\\": \\"auto_block_payment_abuse\\"},\\"time\\": 1613777136497,\\"webhook_succeeded\\": false}}}")
      %Response{decisions: %{payment_abuse: %{decision: %{id: "auto_block_payment_abuse"},time: 1613777136497,webhook_succeeded: false}}}
  """
  @spec process(String.t | map) :: __MODULE__.t
  def process(body) when is_binary(body) do
    body
    |> Poison.decode(keys: :atoms)
    |> case do
         {:ok, response} ->
           process(response)
         {:error, reason} ->
           Logger.error("Invalid (#{reason}) JSON response from Sift Science: #{body}")
           %__MODULE__{}
       end
  end
  def process(body) do
    __MODULE__
    |> struct(body)
  end
end
