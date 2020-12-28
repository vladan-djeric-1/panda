defmodule Cache do
  @doc """
  Get entry from cache
  """
  @callback get(String.t(), Keyword.t()) :: {:ok, term} | {:error, String.t()}

  @doc """
  Put entry in cache
  """
  @callback put(String.t(), any(), Keyword.t()) :: {:ok, term} | {:error, String.t()}

  @doc """
  Delete entry from cache
  """
  @callback del(String.t(), Keyword.t()) :: {:ok, term} | {:error, String.t()}
end
