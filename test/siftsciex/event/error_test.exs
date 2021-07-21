defmodule Siftsciex.Event.ErrorTest do
  use ExUnit.Case, async: true

  alias Siftsciex.Event.Error

  doctest Error

  describe "from_body/2" do
    test "creates an error struct from a json string" do
      body = """
      {
        "status" : 51,
        "error_message" : "Invalid API Key. Please check your credentials and try again.",
        "time" : 1327604222
      }
      """

      error = Error.from_body(:client_error, body)

      assert %Error{
               type: :client_error,
               error_status: 51,
               time: ~U[2012-01-26 18:57:02Z],
               error_message: "Invalid API Key. Please check your credentials and try again."
             } = error
    end
  end

  describe "build/2" do
    test "creates an error struct from a type and a message string" do
      error = Error.build(:client_error, "no donut for you")

      assert not is_nil(error.time)

      assert %Error{
               type: :client_error,
               error_status: nil,
               error_message: "no donut for you"
             } = error
    end
  end
end
