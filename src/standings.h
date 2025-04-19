
#pragma once

#include <string>
#include <vector>

namespace shob::football
{
    class standingsRow
    {
    public:
        std::string team;
        int totalGames;
        int wins;
        int losses;
        int draws;
        int goals;
        int goalsAgainst;
    };

    class standings
    {
    public:
        std::vector<standingsRow> list;
        void addResult(const std::string& team1, const std::string& team2, const int goals1, const int goals2);
    private:
        void addRow(const std::string& team1, const int goals1, const int goals2);
        size_t findIndex(const std::string& team);
    };
}

