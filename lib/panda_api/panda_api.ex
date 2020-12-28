defmodule PandaApi do
  @behaviour HttpClient

  @http_client Application.get_env(:panda, :http_client)
  @base_url Application.fetch_env!(:panda, :panda_api_base_url)
  @api_key Application.fetch_env!(:panda, :panda_api_key)

  defexception message: "API error"

  def http_client, do: @http_client
  def api_key, do: @api_key

  @impl HttpClient
  def get(path, headers \\ [], options \\ []) do
    case http_client().get(@base_url <> path, headers, options) do
      {:ok, %{status_code: 200, body: body}} -> {:ok, Jason.decode!(body, keys: :atoms)}
      {:ok, %{status_code: status_code}} -> {:error, status_code}
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  def get!(path, headers \\ [], options \\ []) do
    case get(path, headers, options) do
      {:ok, data} -> data
      {:error, reason} -> raise "API Error #{reason}"
    end
  end

  def cachable_get(path, headers \\ [], options \\ []) do
    cache_key = @base_url <> path

    case Cache.ApiCache.get(cache_key) do
      {:ok, value} when is_nil(value) == false ->
        {:ok, value}

      _ ->
        case get(path, headers, options) do
          {:ok, json} ->
            Cache.ApiCache.put(cache_key, json, ttl: :timer.seconds(3600))
            {:ok, json}

          {:error, reason} ->
            {:error, reason}
        end
    end
  end

  def cachable_get!(path, headers \\ [], options \\ []) do
    case cachable_get(path, headers, options) do
      {:ok, data} -> data
      {:error, reason} -> raise "API Error #{reason}"
    end
  end

  def call!(method, path, headers \\ [], options \\ []) do
    case method do
      :get -> cachable_get!(path, headers ++ auth_headers(), options)
    end
  end

  def batch(requests) when is_list(requests) do
    execute_api_request = fn {request_id, method, path, headers, options} ->
      {request_id, call!(method, path, headers, options)}
    end

    requests
    |> Task.async_stream(execute_api_request)
    |> Enum.into([], fn {:ok, res} -> res end)
  end

  defp auth_headers, do: [{"Authorization", "Bearer #{@api_key}"}]
end
