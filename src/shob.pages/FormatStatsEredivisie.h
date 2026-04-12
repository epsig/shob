
#pragma once
#include <string>
#include <vector>
#include "../shob.teams/clubTeams.h"
#include "../shob.html/settings.h"
#include "../shob.general/MultipleStrings.h"
#include "../shob.football/results2standings.h"

namespace shob::pages
{
    struct teamWithResult
    {
        std::vector<std::string> team_most;
        int result_most;
        std::vector<std::string> team_least;
        int result_least;
        std::string team_most_to_string() const { return to_string(team_most); }
        std::string team_least_to_string() const { return to_string(team_least); }
    private:
        static std::string to_string(const std::vector<std::string>& data)
        {
            std::string retval;
            for (const auto& s : data)
            {
                if (!retval.empty()) retval += "; ";
                retval += s;
            }
            return retval;
        }
    };

    struct goalsSummary
    {
        teamWithResult goals;
        teamWithResult goals_against;
        teamWithResult difference;
    };

    class FormatStatsEredivisie
    {
    public:
        FormatStatsEredivisie(std::string folder, teams::clubTeams& teams, const html::settings& settings) :
            sportDataFolder(std::move(folder)), teams(std::move(teams)), settings(settings) {}
        void getPagesToFile(bool extraStats, const std::string& filename) const;
        general::MultipleStrings getStats(const bool extraStats) const;
        static std::string getOutputFilename(const std::string& folder, const bool extraStats);
    private:
        const std::string sportDataFolder;
        const teams::clubTeams teams;
        const html::settings settings;
        static void updateOneResult(teamWithResult& result, int x, const std::string& team);
        goalsSummary getGoalsSummary(const football::standings& table) const;
        general::MultipleStrings table1_to_html(const std::vector<std::pair<int, goalsSummary>>& data) const;
    };
}
