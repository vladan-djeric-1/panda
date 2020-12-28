ExUnit.start(exclude: [:skip])

Mox.Server.start_link([])
Mox.defmock(HttpClientMock, for: HTTPoison.Base)
Application.put_env(:panda, :http_client, HttpClientMock)
