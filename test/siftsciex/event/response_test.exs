defmodule Siftsciex.Event.ResponseTest do
  use ExUnit.Case

  alias Siftsciex.Event.Response

  doctest Response

  def time, do: 1_528_999_522
  def date_time do
    {:ok, value} = DateTime.from_unix(1_528_999_522)

    value
  end
end
