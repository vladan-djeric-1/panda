defmodule Cache.ApiCache do
  @behaviour Cache
  @name Application.fetch_env!(:panda, :cache_name)
  @client Application.get_env(:panda, :cache_client)

  def cache_client, do: @client

  @impl Cache
  def put(key, value, options \\ []) do
    cache_client().put(@name, key, value, options)
  end

  @impl Cache
  def get(key, options \\ []) do
    cache_client().get(@name, key, options)
  end

  @impl Cache
  def del(key, options \\ []) do
    cache_client().del(@name, key, options)
  end

  def reset() do
    cache_client().reset(@name)
  end
end
