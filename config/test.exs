use Mix.Config

config :siftsciex,
  currency_factors: [default: &(&1), usd: &(&1 * 100)]
