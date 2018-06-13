defmodule Siftsciex.Event.Payload.PaymentMethodTest do
  use ExUnit.Case

  alias Siftsciex.Event.Payload.PaymentMethod

  doctest PaymentMethod

  test "new/1 accepts `nil` for the payment_gateway" do
    assert %PaymentMethod{"$payment_type": "$credit_card"} = PaymentMethod.new(%{payment_type: :credit_card, payment_gateway: nil})
  end

  test "new/1 removes bad gateway records from a list" do
    expected = [%PaymentMethod{"$payment_type": "$credit_card", "$payment_gateway": "$stripe"}]

    assert ^expected = PaymentMethod.new([%{payment_type: :credit_card, payment_gateway: "stripe"}, %{payment_type: :credit_card, payment_gateway: "bogus"}])
  end
end
