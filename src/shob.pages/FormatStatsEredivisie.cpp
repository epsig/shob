
#include "FormatStatsEredivisie.h"
#include "../shob.html/updateIfNewer.h"

namespace shob::pages
{
    using namespace shob::general;

    void FormatStatsEredivisie::getPagesToFile(bool extraStats, const std::string& filename) const
    {
        auto output = getStats(extraStats);
        html::updateIfDifferent::update(filename, output);
    }

    MultipleStrings FormatStatsEredivisie::getStats(const bool extraStats) const
    {
        auto table1 = std::vector<std::pair<int, goalsSummary>>();

        for (int year = 2025; year >= 1993; year--)
        {
            auto season = Season(year);
            auto file1 = sportDataFolder + "/eredivisie_" + season.toPartFilename() + ".csv";
            auto competition = football::footballCompetition();
            competition.readFromCsv(file1);
            auto table = football::results2standings::u2s(competition);
            auto summary = getGoalsSummary(table);
            table1.emplace_back(year, summary);
        }

        return table1_to_html(table1);
    }

    std::string FormatStatsEredivisie::getOutputFilename(const std::string& folder, const bool extraStats)
    {
        if (extraStats)
        {
            return folder + "sport_voetbal_nl_stats.html";
        }
        else
        {
            return folder + "sport_voetbal_nl_stats_more.html";
        }
    }

    void FormatStatsEredivisie::updateOneResult(teamWithResult& result, int x, const std::string& team )
    {
        if (result.team_most.empty() || result.result_most < x)
        {
            result.result_most = x;
            result.team_most = { team };
        }
        else if (result.result_most == x)
        {
            result.team_most.push_back(team);
        }

        if (result.team_least.empty() || result.result_least > x)
        {
            result.result_least = x;
            result.team_least = { team };
        }
        else if (result.result_least == x)
        {
            result.team_least.push_back(team);
        }
    }

    goalsSummary FormatStatsEredivisie::getGoalsSummary(const football::standings& table)
    {
        auto summary = goalsSummary();
        for (const auto& result : table.list)
        {
            updateOneResult(summary.goals, result.goals, result.team);
            updateOneResult(summary.goals_against, result.goalsAgainst, result.team);
            updateOneResult(summary.difference, result.goalDifference(), result.team);
        }
        return summary;
    }

    MultipleStrings FormatStatsEredivisie::table1_to_html(const std::vector<std::pair<int, goalsSummary>>& data) const
    {
        html::tableContent content;
        if (settings.lang == html::language::English)
        {
            content.header.data = { "season", "most goals", "least goals", "most goals against", "least goals against", "highest goal difference", "lowest goal difference" };
            content.title = "Min / max Totals of the goals ";
        }
        else
        {
            content.header.data = { "seizoen", "meeste goals", "minste goals", "meeste tegengoals", "minste tegengoals", "hoogste doelsaldo", "laagste doelsaldo" };
            content.title = "Min / max Totalen van de doelpunten ";
        }

        for (const auto& [year, summary] : data)
        {
            auto szn = Season(year);
            MultipleStrings body;
            body.data = { szn.toStringShort(),
                summary.goals.team_most_to_string() + " " + std::to_string(summary.goals.result_most),
                summary.goals.team_least_to_string() + " " + std::to_string(summary.goals.result_least),
                summary.goals_against.team_most_to_string() + " " + std::to_string(summary.goals_against.result_most),
                summary.goals_against.team_least_to_string() + " " + std::to_string(summary.goals_against.result_least),
                summary.difference.team_most_to_string() + " " + std::to_string(summary.difference.result_most),
                summary.difference.team_least_to_string() + " " + std::to_string(summary.difference.result_least)
            };
            content.body.push_back(body);
        }
        const auto Table = html::table(settings);
        auto table = Table.buildTable(content);
        auto return_value = MultipleStrings();
        return_value.addContent(table);
        return return_value;
    }
}
