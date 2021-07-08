use Mix.Config

config :siftsciex,
  currency_factors: [usd: {Siftsciex.Support.Converter, :usd}],
  api_key: "test_key",
  events_url: "https://api.siftscience.com/v205/events",
  users_url: "https://api.siftscience.com/v205/users",
  score_url: "https://api.siftscience.com/v205/score",
  http_transport: Siftsciex.Support.MockRequest
