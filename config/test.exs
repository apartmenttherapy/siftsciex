use Mix.Config

config :siftsciex,
  currency_factors: [usd: {Siftsciex.Support.Converter, :usd}],
  api_key: "test_key",
  events_url: "https://api.siftscience.com/v205/events",
  http_transport: Siftsciex.Support.MockRequest
