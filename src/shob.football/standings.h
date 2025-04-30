
#pragma once

#include <string>
#include <vector>
#include "../shob.html/table.h"
#include "../shob.html/settings.h"
#include "../shob.teams/clubTeams.h"

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
        void handlePunishment(const std::string team, const int pnts);
        html::tableContent prepareTable(const teams::clubTeams & teams, const html::settings & settings) const;
    private:
        void addRow(const std::string& team1, const int goals1, const int goals2);
        size_t findIndex(const std::string& team);
    };
}

