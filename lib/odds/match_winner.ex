defmodule Odds.MatchWinner do
  @precision 8

  def from_win_loss_records([{team_a_id, %{total: 0}}, {team_b_id, %{total: 0}}]) do
    %{team_a_id => 0.5, team_b_id => 0.5}
  end

  def from_win_loss_records([{team_a_id, stats_a}, {team_b_id, stats_b}])
      when stats_a.total == stats_b.total do
    odd_a =
      ((stats_a.victories + stats_b.losses) / (stats_a.total + stats_b.total))
      |> Float.round(@precision)

    odd_b =
      ((stats_b.victories + stats_a.losses) / (stats_b.total + stats_b.total))
      |> Float.round(@precision)

    %{team_a_id => odd_a, team_b_id => odd_b, nil: (1 - odd_a - odd_b) |> Float.round(@precision)}
  end

  def combine_odds([{odds_1, weight_1}, {odds_2, weight_2}]) do
    [team_id_1, team_id_2] = odds_1 |> Map.keys()
    total_weight = weight_1 + weight_2

    %{
      team_id_1 =>
        ((odds_1[team_id_1] * weight_1 + odds_2[team_id_1] * weight_2) / total_weight)
        |> Float.round(@precision),
      team_id_2 =>
        ((odds_1[team_id_2] * weight_1 + odds_2[team_id_2] * weight_2) / total_weight)
        |> Float.round(@precision)
    }
  end
end
