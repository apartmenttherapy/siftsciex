defmodule Siftsciex.Event.AccountTest do
  use ExUnit.Case

  alias Siftsciex.Event.Account
  alias Siftsciex.Event.Payload.{PaymentMethod, Address, Promotion}

  doctest Account

  def api_key, do: "test_key"
end
