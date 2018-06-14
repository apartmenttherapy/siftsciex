defmodule Siftsciex.Event.ResponseTest do
  use ExUnit.Case

  alias Siftsciex.Event.Response

  doctest Response

  def time, do: 1528999522
  def date_time do
    {:ok, value} = DateTime.from_unix(1528999522)

    value
  end
end
