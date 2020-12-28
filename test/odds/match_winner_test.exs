defmodule Odds.MatchWinnerTest do
  use ExUnit.Case
  doctest Odds.MatchWinner

  describe "from_win_loss_records/1" do
    test "when teams have same number of victories, odds are even" do
      victory_stats = [
        {1, %{victories: 7, losses: 3, draws: 0, total: 10}},
        {2, %{victories: 7, losses: 3, draws: 0, total: 10}}
      ]

      assert Odds.MatchWinner.from_win_loss_records(victory_stats) == %{
               1 => 0.5,
               2 => 0.5,
               nil => 0
             }
    end

    test "when teams have only losses, odds are even" do
      victory_stats = [
        {1, %{victories: 0, losses: 10, draws: 0, total: 10}},
        {2, %{victories: 0, losses: 10, draws: 0, total: 10}}
      ]

      assert Odds.MatchWinner.from_win_loss_records(victory_stats) == %{
               1 => 0.5,
               2 => 0.5,
               nil => 0
             }
    end

    test "when a team has more victories than the other, his odd is higher" do
      victory_stats = [
        {1, %{victories: 8, losses: 2, draws: 0, total: 10}},
        {2, %{victories: 4, losses: 6, draws: 0, total: 10}}
      ]

      assert Odds.MatchWinner.from_win_loss_records(victory_stats) == %{
               1 => 0.7,
               2 => 0.3,
               nil => 0
             }
    end

    test "take into acounts draw games" do
      victory_stats = [
        {1, %{victories: 5, losses: 2, draws: 3, total: 10}},
        {2, %{victories: 4, losses: 4, draws: 2, total: 10}}
      ]

      assert Odds.MatchWinner.from_win_loss_records(victory_stats) == %{
               1 => 0.45,
               2 => 0.3,
               nil => 0.25
             }
    end
  end
end
