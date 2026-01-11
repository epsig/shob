
#pragma once

#include <string>
#include <vector>
#include <map>
#include "../shob.html/table.h"
#include "../shob.html/settings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.general/Season.h"

namespace shob::football
{
    class standingsRow
    {
    public:
        bool compareTo(const standingsRow& other) const;
        bool compareTo6(const standingsRow& other) const;
        int goalDifference() const { return goals - goalsAgainst; }
        std::string team;
        int totalGames = 0;
        int wins = 0;
        int losses = 0;
        int draws = 0;
        int goals = 0;
        int goalsAgainst = 0;
        int points = 0;
        int punishmentPoints = 0;
        std::map<std::string, bool> mutualResults;
        int awayWins = 0;
        int awayGoals = 0;
        int sumPointsOpponents = 0;
        int sumGoalDiffOpponents = 0;
        int sumGoalsOpponents = 0;
    };

    class u2sExtra
    {
    public:
        std::vector<std::string> extras;
    };

    struct compactMatch
    {
        std::string team1;
        std::string team2;
        int goals1;
        int goals2;
    };

    class standings
    {
    public:
        standings();
        std::vector<standingsRow> list;
        void addResult(const std::string& team1, const std::string& team2, const int goals1, const int goals2);
        void addResultHome(const std::string& team, const int goals1, const int goals2);
        void addResultAway(const std::string& team, const int goals1, const int goals2);
        void addExtras(const readers::csvAllSeasonsReader& r, const general::Season& season);
        void sort(const int sort_rule = 3);
        void initFromFile(const std::string& filename);
        void initFromData(const readers::csvContent& stand);
        void handlePunishment(const std::string team, const int pnts);
        html::tableContent prepareTable(const teams::clubTeams & teams, const html::settings & settings) const;
        int wns_cl = -1;
        int scoring = 3;
        void addNecessaryMutualResults(const std::vector<compactMatch>& matches);
        void addResultsOpponents(const std::vector<compactMatch>& matches);
    private:
        std::map<std::string, u2sExtra> extras;
        std::map<std::string, std::string> mapExtra;
        void addRow(const std::string& team1, const int goals1, const int goals2, const bool switched);
        size_t findIndex(const std::string& team);
        void updateTeamWithExtras(std::string& team, const std::vector<std::string>& extraData, const int punishment) const;
        void updateTeamWithWnsCl(std::string& team, const size_t i) const;
        void expandExtra(std::string& extra) const;
        size_t findIndex(const std::string& team) const;
    };
}

