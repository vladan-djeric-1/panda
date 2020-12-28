import Config

config :panda,
  port: 8081,
  panda_api_base_url: "http://localhost:3001",
  panda_api_key: "the-panda-api-key",
  http_client: HttpClientMock,
  cache_client: Cachex,
  cache_name: :panda_cache_test
