import Config

config :panda,
  port: 8080,
  panda_api_base_url: "https://api.pandascore.co",
  panda_api_key: "YOUR_API_KEY",
  http_client: HTTPoison,
  cache_client: Cachex,
  cache_name: :panda_cache_dev
