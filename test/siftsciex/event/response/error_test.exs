defmodule Siftsciex.Event.Response.ErrorTest do
  use ExUnit.Case

  alias Siftsciex.Event.Response
  alias Siftsciex.Event.Response.Error

  doctest Error

  def response do
    %Response{status: 60}
  end
end
