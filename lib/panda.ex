defmodule Panda do
  def upcoming_matches do
    PandaApi.Matches.upcoming(5)
    |> Enum.map(&Map.take(&1, [:scheduled_at, :id, :name]))
  end

  def winning_probabilities_for_match(match_id) do
    PandaApi.Matches.get(match_id)
    |> compute_winning_probabilities_for_match
  end

  def compute_winning_probabilities_for_match(match) when match.status != "not_started", do: nil
  def compute_winning_probabilities_for_match(match) when length(match.opponents) != 2, do: nil

  def compute_winning_probabilities_for_match(match) do
    teams = match.opponents |> Enum.map(&struct(Team, &1.opponent))
    teams_map = Enum.into(teams, %{}, fn team -> {team.id, team} end)

    teams
    |> Enum.map(fn team -> team.id end)
    |> Stats.TeamStats.win_losses_record(10)
    |> Odds.MatchWinner.from_win_loss_records()
    |> format_winning_probabilities(teams_map)
  end

  defp format_winning_probabilities(odds, teams_map) do
    odds
    |> Enum.reduce(%{}, fn {team_id, odd}, acc ->
      team = Map.get(teams_map, team_id)

      if is_nil(team_id) do
        Map.put(acc, "Draw", odd)
      else
        Map.put(acc, team.name, odd)
      end
    end)
  end
end
