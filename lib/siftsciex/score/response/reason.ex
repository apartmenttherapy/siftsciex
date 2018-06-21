defmodule Siftsciex.Score.Response.Reason do
  @moduledoc """
  Represents a reason for a Sift Score
  """

  defstruct name: :empty, value: :empty, details: :empty
  @type t :: %__MODULE__{name: :empty | String.t, value: :empty | String.t, details: :empty | map | String.t}
  @type str_key :: :name | :value
  @type data :: %{optional(str_key) => String.t,
                  :details => String.t | map}

  @doc """
  Creates a new `t:Siftscience.Score.Response.Reason.t/0` struct from a response

  ## Parameters

    - `data`: A single or list of maps to be turned into structs

  ## Examples

      iex> Reason.new(%{name: "Bob", value: "Fraudster", details: %{"users" => "a, b, c"}})
      %Reason{name: "Bob", value: "Fraudster", details: %{"users" => "a, b, c"}}

      iex> Reason.new(%{name: "Bob", value: "Fraudster", details: "fake stuff"})
      %Reason{name: "Bob", value: "Fraudster", details: "fake stuff"}

      iex> Reason.new(%{name: "Bob", value: "Fraudster"})
      %Reason{name: "Bob", value: "Fraudster", details: :empty}

      iex> Reason.new([%{name: "Bob", value: "Fraudster"}, %{name: "Sue", value: "Criminal"}])
      [%Reason{name: "Bob", value: "Fraudster"}, %Reason{name: "Sue", value: "Criminal"}]

  """
  @spec new(data | [data]) :: __MODULE__.t
  def new(data) when is_list(data) do
    Enum.map(data, &new/1)
  end
  def new(data) do
    normalized = normalize(data)

    struct(__MODULE__, normalized)
  end

  defp normalize(data) do
    details = Map.get(data, :details, :empty)

    Map.put(data, :details, process_details(details))
  end

  defp process_details(:empty), do: :empty
  defp process_details(details) when is_map(details) do
    details
  end
  defp process_details(details) do
    case Poison.decode(details) do
      {:ok, json} ->
        json
      {:error, _} ->
        details
    end
  end
end
