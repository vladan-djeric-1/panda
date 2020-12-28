defmodule Match do
  @enforce_keys [:id, :status]
  defstruct [:id, :name, :status, :winner_id, :opponents]
end
