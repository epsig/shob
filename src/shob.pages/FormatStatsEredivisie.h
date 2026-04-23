
#pragma once
#include <string>
#include <vector>
#include "../shob.teams/clubTeams.h"
#include "../shob.html/settings.h"
#include "../shob.general/MultipleStrings.h"
#include "../shob.football/results2standings.h"
#include "../shob.football/topscorers.h"

namespace shob::pages
{
    struct teamWithResult
    {
        std::vector<std::string> teams;
        int result = 0;
        std::string to_string() const
        {
            std::string retval;
            for (const auto& s : teams)
            {
                if (!retval.empty()) retval += "; ";
                retval += s;
            }
            return retval;
        }
    };

    struct teamWithMinMaxResults
    {
        teamWithResult min;
        teamWithResult max;
    };

    struct goalsSummary
    {
        teamWithMinMaxResults goals;
        teamWithMinMaxResults goals_against;
        teamWithMinMaxResults difference;
    };

    struct sumGoalsAndMatches
    {
        int sumGoals = 0;
        int sumMatches = 0;
    };

    class FormatStatsEredivisie
    {
    public:
        FormatStatsEredivisie(std::string folder, teams::clubTeams& teams, const html::settings& settings) :
            sportDataFolder(std::move(folder)), teams(std::move(teams)), settings(settings) {}
        void getPagesToFile(const bool extraStats, const std::string& filename) const;
        general::MultipleStrings getStats(const bool extraStats) const;
        static std::string getOutputFilename(const std::string& folder, const bool extraStats);
    private:
        const std::string sportDataFolder;
        const teams::clubTeams teams;
        const html::settings settings;
        static void updateOneResult(teamWithMinMaxResults& result, const int x, const std::string& team);
        goalsSummary getGoalsSummary(const football::standings& table) const;
        static sumGoalsAndMatches getSumGoalsAndMatches(const football::standings& table);
        static std::string getButton(const std::string& id, const int col, const int updown);
        general::MultipleStrings table1_to_html(const std::vector<std::pair<general::Season, goalsSummary>>& data) const;
        general::MultipleStrings table2_to_html(const std::vector<std::pair<general::Season, sumGoalsAndMatches>>& data,
            const std::vector<std::pair<general::Season, football::numbers1>>& topscorers) const;
    };
}
