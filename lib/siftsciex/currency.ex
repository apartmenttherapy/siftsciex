defmodule Siftsciex.Currency do
  @moduledoc """
  The Currency module handles the translation of price values from the client unit to the "base in micros" units Sift Science expects.  Most of the logic here is governed by configuration values.  `Siftsciex` performs all calculations relative to the base unit for the currency given.  This means that the library needs to know if a value is a quantity of that base unit or some other multiple of that unit.  The `:currency_factors` configuration value allows you to tell `Siftsciex` how to convert a value to the base unit for the currency being used.
  """

  require Logger

  @doc """
  Converts the given amount for the given currency to the corresponding `micros` value based on the configuration for that currency.

  ## Parameters

    - `amount`: The amount that should be converted as an `integer`
    - `type`: The currency type, if no configuration is found for that currency then the `default` configuration factor will be used, if there no configuration is found for that currency and no `:default` is set then the value will be converted directly to micros (amount * 10_000)

  ## Examples

      iex> Currency.as_micros(8, "USD")
      8000000

      iex> Currency.as_micros(8, :usd)
      8000000

      iex> Currency.as_micros(800, :unknown)
      8000000

  """
  @spec as_micros(integer, String.t | atom) :: integer
  def as_micros(amount, type \\ :default) do
    {mod, fun} = base_converter(type)
    base = Kernel.apply(mod, fun, [amount])

    base * 10_000
  end

  def base_converter(type) when is_binary(type) do
    type
    |> String.downcase()
    |> String.to_atom()
    |> base_converter()
  end
  def base_converter(type) when is_atom(type) do
    converters = factors()

    converters[type]
    |> case do
         nil ->
           Logger.info("Unconfigured currency type received (#{Kernel.inspect(type)})")
           converters[:default] || {__MODULE__, :default}
         fun ->
           fun
       end
  end

  defp factors, do: Application.get_env(:siftsciex, :currency_factors)

  @doc false
  @spec default(integer | float) :: integer | float
  def default(value), do: value
end
