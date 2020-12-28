defmodule PandaApi.Matches do
  @base_path "/matches"

  def get(match_id) do
    Match
    |> struct(PandaApi.call!(:get, @base_path <> "/#{match_id}"))
  end

  def upcoming(limit) when is_integer(limit) do
    PandaApi.call!(:get, @base_path <> "/upcoming?per_page=#{limit}&sort=begin_at")
  end

  def opponents(match_id) do
    PandaApi.call!(:get, @base_path <> "/#{match_id}/opponents")
    |> Map.get("opponents")
    |> Enum.map(fn team -> %Team{id: team["id"], name: team["name"]} end)
  end
end
