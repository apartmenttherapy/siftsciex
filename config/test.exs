use Mix.Config

config :siftsciex,
  currency_factors: [default: &(&1), usd: &(&1 * 100)],
  api_key: "test_key",
  events_url: "https://api.siftscience.com/v205/events",
  http_transport: Siftsciex.Support.MockRequest
