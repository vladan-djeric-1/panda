defmodule Stats.TeamStats do
  def win_losses_record(teams_ids, nb_matches) when is_list(teams_ids) do
    teams_ids
    |> PandaApi.Teams.fetch_last_matches(nb_matches)
    |> take_same_matches_length()
    |> compute_win_loss_records()
  end

  def compute_win_loss_records([]), do: []

  def compute_win_loss_records([{team_id, matches} | list]) do
    stats = compute_win_loss_record(matches, team_id)
    [{team_id, stats} | compute_win_loss_records(list)]
  end

  def compute_win_loss_record(matches, team_id) when is_integer(team_id) do
    matches
    |> Enum.reduce(%{victories: 0, losses: 0, draws: 0, total: length(matches)}, fn match,
                                                                                    stats ->
      case match.winner_id do
        nil -> update_in(stats.draws, &(&1 + 1))
        ^team_id -> update_in(stats.victories, &(&1 + 1))
        _ -> update_in(stats.losses, &(&1 + 1))
      end
    end)
  end

  defp take_same_matches_length(teams_matches) do
    min =
      teams_matches
      |> Enum.map(fn {_, matches} -> length(matches) end)
      |> Enum.min()

    teams_matches
    |> Enum.map(fn {team_id, matches} -> {team_id, Enum.take(matches, min)} end)
  end
end
