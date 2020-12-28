defmodule PandaApi.Teams do
  @base_path "/teams"

  def fetch_last_matches(team_ids, nb_matches) when is_list(team_ids) do
    team_ids
    |> Enum.map(&build_last_matches_requests(&1, nb_matches))
    |> PandaApi.batch()
  end

  defp build_last_matches_requests(team_id, nb_matches) do
    path = "/#{team_id}/matches?filter[status]=finished&sort=-begin_at&per_page=#{nb_matches}"
    {team_id, :get, @base_path <> path, [], []}
  end
end
