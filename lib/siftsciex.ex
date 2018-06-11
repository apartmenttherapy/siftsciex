defmodule Siftsciex do
  @moduledoc """
  Documentation for Siftsciex.
  """

  def mark(key), do: String.to_atom("$#{key}")
end
