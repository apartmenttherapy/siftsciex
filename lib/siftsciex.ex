defmodule Siftsciex do
  @moduledoc """
  Documentation for Siftsciex.
  """

  @doc false
  def mark(key), do: String.to_atom("$#{key}")

  @doc false
  def mark_string(value), do: "$#{value}"
end
