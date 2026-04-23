
#include "FormatStatsEredivisie.h"
#include "HeadBottom.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.football/topscorers.h"
#include "../shob.general/MathSupport.h"
#include <format>
#include <filesystem>

namespace shob::pages
{
    namespace fs = std::filesystem;

    using namespace shob::general;

    void FormatStatsEredivisie::getPagesToFile(const bool extraStats, const std::string& filename) const
    {
        const auto output = getStats(extraStats);
        html::updateIfDifferent::update(filename, output);
    }

    MultipleStrings FormatStatsEredivisie::getStats(const bool extraStats) const
    {
        auto table1 = std::vector<std::pair<Season, goalsSummary>>();
        auto table2 = std::vector<std::pair<Season, sumGoalsAndMatches>>();
        auto table2b = std::vector<std::pair<Season, football::numbers1>>();
        int dd = 0;

        auto players = teams::footballers();
        const std::string filename3 = sportDataFolder + "/../voetballers.csv";
        players.initFromFile(filename3);

        auto file_tp_eredivisie = sportDataFolder + "/topscorers_eredivisie.csv";
        auto allTp = readers::csvAllSeasonsReader();
        allTp.init(file_tp_eredivisie);

        const int startYear = extraStats ? 2025 : 2024;
        const int lastYear = extraStats ? 1956 : 1993;
        for (int year = startYear; year >= lastYear; year--)
        {
            const auto season = Season(year);
            football::standings table;
            const auto file1 = sportDataFolder + "/eredivisie_" + season.toPartFilename() + ".csv";
            const auto file2 = sportDataFolder + "/eindstand_eredivisie_" + season.toPartFilename() + ".csv";
            if (fs::exists(file1))
            {
                auto competition = football::footballCompetition();
                competition.readFromCsv(file1);
                dd = std::max(dd, competition.lastDate().toInt());
                table = football::results2standings::u2s(competition);
            }
            else if (fs::exists(file2))
            {
                table = football::standings();
                table.initFromFile(file2);
            }
            else
            {
                continue;
            }
            const auto summary = getGoalsSummary(table);
            table1.emplace_back(season, summary);
            const auto summary2 = getSumGoalsAndMatches(table);
            table2.emplace_back(season, summary2);

            auto tp = football::topscorers(allTp);
            tp.initFromFile(season);
            const auto tpSummary = tp.getNumbers1(teams, players);
            table2b.emplace_back(season, tpSummary);
        }

        auto topmenu = MultipleStrings();
        topmenu.addContent("<hr>| <a href=\"#extr_goals\">meeste/minste goals</a>");
        topmenu.addContent("| <a href=\"#tot_goals\">totaal goals/topscorers</a>");
        // | <a href="#extr_uitsl">opvallende uitslagen</a>
        // | <a href="#toesch">toeschouwersaantallen</a>
        if (extraStats)
        {
            topmenu.addContent("| <a href=\"sport_voetbal_nl_stats.html\">samengevat</a>");
        }
        else
        {
            topmenu.addContent("| <a href=\"sport_voetbal_nl_stats_more.html\">meer stats</a>");
        }
        topmenu.addContent("|<hr>");

        auto return_value1 = table1_to_html(table1);
        auto return_value2 = table2_to_html(table2, table2b);

        auto hb = HeadBottomInput(dd);
        hb.title = "Statistieken eredivisie";
        hb.js = JavaScriptType::SortTable;
        std::swap(hb.body, topmenu);
        hb.body.addContent(return_value1);
        hb.body.addContent(return_value2);

        return HeadBottom::getPage(hb);
    }

    std::string FormatStatsEredivisie::getOutputFilename(const std::string& folder, const bool extraStats)
    {
        if (extraStats)
        {
            return folder + "sport_voetbal_nl_stats_more.html";
        }
        else
        {
            return folder + "sport_voetbal_nl_stats.html";
        }
    }

    void FormatStatsEredivisie::updateOneResult(teamWithResult& result, const int x, const std::string& team)
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

    goalsSummary FormatStatsEredivisie::getGoalsSummary(const football::standings& table) const
    {
        auto summary = goalsSummary();
        for (const auto& result : table.list)
        {
            auto team = teams.expand(result.team);
            updateOneResult(summary.goals, result.goals, team);
            updateOneResult(summary.goals_against, result.goalsAgainst, team);
            updateOneResult(summary.difference, result.goalDifference(), team);
        }
        return summary;
    }

    sumGoalsAndMatches FormatStatsEredivisie::getSumGoalsAndMatches(const football::standings& table)
    {
        auto summary = sumGoalsAndMatches();
        for (const auto& result : table.list)
        {
            summary.sumGoals += result.goals;
            summary.sumMatches += result.totalGames;
        }
        summary.sumMatches /= 2; // the sum counts everything double
        return summary;
    }

    std::string FormatStatsEredivisie::getButton(const std::string& id, const int col, const int updown)
    {
        const std::string arrow = updown == 1 ? "&darr;" : "&uarr;";
        return std::format("<button onclick=\"sortTable('{}', {}, 1, {})\"> <b> {} </b> </button>", id, col, updown, arrow);
    }

    MultipleStrings FormatStatsEredivisie::table1_to_html(const std::vector<std::pair<Season, goalsSummary>>& data) const
    {
        html::tableContent content1;

        if (settings.lang == html::language::English)
        {
            content1.header.data = { "season", "most goals", "least goals", "most goals against", "least goals against",
                "highest goal difference", "lowest goal difference" };
        }
        else
        {
            content1.header.data = { "seizoen", "meeste goals", "minste goals", "meeste tegengoals", "minste tegengoals",
                "hoogste doelsaldo", "laagste doelsaldo" };
        }

        for (int updown = 1; updown <= 2; updown++)
        {
            for (int i = 1; i < static_cast<int>(content1.header.data.size()); i++)
            {
                content1.header.data[i] += getButton("id2", 2 * i, updown);
            }
        }

        content1.colWidths = { 1, 2, 2, 2, 2, 2, 2 };

        html::tableContent content;
        content.header.data = {};

        for (const auto& [szn, summary] : data)
        {
            MultipleStrings body;
            body.data = { szn.toString(),
                summary.goals.team_most_to_string(), std::format("{:3}", summary.goals.result_most),
                summary.goals.team_least_to_string(), std::format("{:3}",summary.goals.result_least),
                summary.goals_against.team_most_to_string(), std::format("{:3}",summary.goals_against.result_most),
                summary.goals_against.team_least_to_string(), std::format("{:3}",summary.goals_against.result_least),
                summary.difference.team_most_to_string(), "+" + std::format("{:3}",summary.difference.result_most),
                summary.difference.team_least_to_string(), std::format("{:3}",summary.difference.result_least)
            };
            content.body.push_back(body);
        }
        auto Table = html::table(settings);
        Table.id = "id2";
        auto return_value = MultipleStrings();
        return_value.addContent("<a name=\"extr_goals\">");
        return_value.addContent("<p>Gebruik pijltje om te sorteren</p>");
        auto table = Table.buildTable({ content1, content });
        return_value.addContent(table);
        if (data.back().first.getFirstYear() == 1956)
        {
            return_value.addContent("<p>seizoen 2019-2020 is over 232 wedstrijden; seizoenen 1962-1963 t/m 1965-1966 over 240 wedstrijden en de overige seizoenen over 306 wedstrijden.</p>");
        }
        else
        {
            return_value.addContent("<p>seizoen 2019-2020 is over 232 wedstrijden; overige over 306.</p>");
        }
        return return_value;
    }


    MultipleStrings FormatStatsEredivisie::table2_to_html(const std::vector<std::pair<Season, sumGoalsAndMatches>>& data,
        const std::vector<std::pair<Season, football::numbers1>>& topscorers) const
    {
        html::tableContent content;

        if (settings.lang == html::language::English)
        {
            content.header.data = { "season", "goals", "average", "name topscorer", "number of goals" };
        }
        else
        {
            content.header.data = { "seizoen", "doelpunten", "gemiddelde", "naam topscorer", "aantal goals" };
        }

        for (int updown = 1; updown <= 2; updown++)
        {
            for (const int i : {1, 2, 4})
            {
                if (updown == 1) content.header.data[i] += "<br>";
                content.header.data[i] += getButton("id3", i, updown);
            }
        }

        for (size_t i = 0; i < data.size(); i++)
        {
            const auto& szn = data[i].first;
            const auto& summary = data[i].second;
            const auto& tp = topscorers[i].second;
            if ( ! tp.ListNamesWithClubs.empty())
            {
                MultipleStrings body;
                auto names = tp.ListNamesWithClubs[0];
                if (tp.ListNamesWithClubs.size() > 1)
                {
                    names += "<br>" + tp.ListNamesWithClubs[1];
                }
                body.data = { szn.toString(),
                    std::format("{:4}", summary.sumGoals),
                    std::format("{:5.03f}", MathSupport::divide(summary.sumGoals, summary.sumMatches)),
                    names, std::format("{:2}", tp.goals)
                };
                content.body.push_back(body);
            }
        }

        auto return_value = MultipleStrings();
        return_value.addContent("<a name=\"tot_goals\">");
        auto Table = html::table(settings);
        Table.id = "id3";
        auto table = Table.buildTable( content);
        return_value.addContent(table);
        return return_value;
    }
}
