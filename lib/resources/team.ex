defmodule Team do
  @enforce_keys [:id, :name]
  defstruct [:id, :name, :acronym]
end
