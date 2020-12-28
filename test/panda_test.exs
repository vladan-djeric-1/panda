defmodule PandaTest do
  use ExUnit.Case
  import Mox
  doctest Panda

  defp load_fixture(path) do
    File.read!("test/support/fixtures" <> path)
  end

  describe "Panda.upcoming_matches/0" do
    test "returns array of matches with correct attributes" do
      expect(
        HttpClientMock,
        :get,
        fn "http://localhost:3001/matches/upcoming?per_page=5&sort=begin_at",
           [{"Authorization", "Bearer the-panda-api-key"}],
           [] ->
          {:ok, %{status_code: 200, body: load_fixture("/panda_api/upcoming_matches.json")}}
        end
      )

      assert Panda.upcoming_matches() == [
               %{
                 id: 577_537,
                 name: "HauntedFamily vs FATE",
                 scheduled_at: "2020-12-15T09:00:00Z"
               }
             ]
    end
  end

  describe "Panda.winning_probabilities_for_match/1" do
    test "when opponent is tbd, returns nil" do
      expect(HttpClientMock, :get, fn "http://localhost:3001/matches/1",
                                      [{"Authorization", "Bearer the-panda-api-key"}],
                                      [] ->
        {:ok, %{status_code: 200, body: load_fixture("/panda_api/match_with_tbd_opponent.json")}}
      end)

      assert Panda.winning_probabilities_for_match(1) == nil
    end

    test "when match is finished, returns nil" do
      expect(HttpClientMock, :get, fn "http://localhost:3001/matches/1",
                                      [{"Authorization", "Bearer the-panda-api-key"}],
                                      [] ->
        {:ok, %{status_code: 200, body: load_fixture("/panda_api/match_finished.json")}}
      end)

      assert Panda.winning_probabilities_for_match(1) == nil
    end

    test "match is upcoming, returns probabilities for teams" do
      expect(HttpClientMock, :get, fn "http://localhost:3001/matches/578141",
                                      [{"Authorization", "Bearer the-panda-api-key"}],
                                      [] ->
        {:ok, %{status_code: 200, body: load_fixture("/panda_api/match_578141.json")}}
      end)

      expect(
        HttpClientMock,
        :get,
        fn "http://localhost:3001/teams/127954/matches?filter[status]=finished&sort=-begin_at&per_page=10",
           [{"Authorization", "Bearer the-panda-api-key"}],
           [] ->
          {:ok, %{status_code: 200, body: load_fixture("/panda_api/team_127954_matches.json")}}
        end
      )

      expect(
        HttpClientMock,
        :get,
        fn "http://localhost:3001/teams/127952/matches?filter[status]=finished&sort=-begin_at&per_page=10",
           [{"Authorization", "Bearer the-panda-api-key"}],
           [] ->
          {:ok, %{status_code: 200, body: load_fixture("/panda_api/team_127952_matches.json")}}
        end
      )

      assert Panda.winning_probabilities_for_match(578_141) == %{
               "Confession" => 0.5,
               "Im Not Over" => 0.4,
               "Draw" => 0.1
             }
    end
  end
end
