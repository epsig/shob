
#pragma once
#include <string>
#include <unordered_map>
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

    struct strikingResults
    {
        std::vector<football::footballMatch> biggestVictory;
        std::vector<football::footballMatch> mostGoalsPerTeam;
        std::vector<football::footballMatch> mostGoalsPerMatch;
    };

    struct spectatorResults
    {
        int totalSpectators = 0;
        double meanSpectators = 0.0;
        std::vector<football::footballMatch> mostSpectators;
        std::vector<football::footballMatch> leastSpectators;
        std::vector<std::pair<std::string, double>> teamsWithMostSpectators;
        std::vector<std::pair<std::string, double>> teamsWithLeastSpectators;
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
        static strikingResults getStrikingResults(const football::footballCompetition& competition);
        static std::vector<std::pair<std::string, double>> findExtremeValueInMap(const std::unordered_map<std::string, double>& data,
                                                                double factor);
        static spectatorResults getSpectatorStats(const football::footballCompetition& competition);
        static void updateStatsFromRemarks(spectatorResults& spectatorsStats,
                                    const std::vector<std::vector<std::string>>& current_remarks);
        static std::string getButton(const std::string& id, const int col, const int updown);
        general::MultipleStrings table1_to_html(const std::vector<std::pair<general::Season, goalsSummary>>& data) const;
        general::MultipleStrings table2_to_html(const std::vector<std::pair<general::Season, sumGoalsAndMatches>>& data,
            const std::vector<std::pair<general::Season, football::numbers1>>& topscorers) const;
        void getFieldsTable3(const std::vector<football::footballMatch>& matches, std::string& matchNames,
                             std::string& results) const;
        general::MultipleStrings table3_to_html(const std::vector<std::pair<general::Season, strikingResults>>& results) const;
        general::MultipleStrings table4a_to_html(const std::vector<std::pair<general::Season, spectatorResults>>& results) const;
        general::MultipleStrings table4b_to_html(const std::vector<std::pair<general::Season, spectatorResults>>& results) const;
    };
}
