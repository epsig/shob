
#pragma once

#include <string>
#include <vector>

namespace shob::football
{
    class standingsRow
    {
    public:
        bool compareTo(const standingsRow& other) const;
        int goalDifference() const { return goals - goalsAgainst; }
        std::string team;
        int totalGames = 0;
        int wins = 0;
        int losses = 0;
        int draws = 0;
        int goals = 0;
        int goalsAgainst = 0;
        int points = 0;
    };

    class standings
    {
    public:
        std::vector<standingsRow> list;
        void addResult(const std::string& team1, const std::string& team2, const int goals1, const int goals2);
        void sort();
    private:
        void addRow(const std::string& team1, const int goals1, const int goals2);
        size_t findIndex(const std::string& team);
    };
}

