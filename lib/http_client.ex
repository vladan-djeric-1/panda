defmodule HttpClient do
  @doc """
  Execute a GET API requests 
  """
  @callback get(String.t(), list, list) :: {:ok, term} | {:error, String.t()}
end
