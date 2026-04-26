
#include "FormatStatsEredivisie.h"
#include "HeadBottom.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.football/topscorers.h"
#include "../shob.general/MathSupport.h"
#include <format>
#include <filesystem>
#include <unordered_map>

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
        auto table3 = std::vector<std::pair<Season, strikingResults>>();
        auto table4 = std::vector<std::pair<Season, spectatorResults>>();
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
            auto competition = football::footballCompetition();
            if (fs::exists(file1))
            {
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

            if ( ! competition.matches.empty())
            {
                const auto striking_results = getStrikingResults(competition);
                table3.emplace_back(season, striking_results);
                const auto spectatorsStats = getSpectatorStats(competition);
                table4.emplace_back(season, spectatorsStats);
            }
        }

        auto topmenu = MultipleStrings();
        topmenu.addContent("<hr>| <a href=\"#extr_goals\">meeste/minste goals</a>");
        topmenu.addContent("| <a href=\"#tot_goals\">totaal goals/topscorers</a>");
        topmenu.addContent("| <a href=\"#extr_uitsl\">opvallende uitslagen</a>");
        topmenu.addContent("| <a href=\"#toesch\">toeschouwersaantallen</a>");
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
        auto return_value3 = table3_to_html(table3);
        auto return_value4 = table4a_to_html(table4);

        auto hb = HeadBottomInput(dd);
        hb.title = "Statistieken eredivisie";
        hb.js = JavaScriptType::SortTable;
        std::swap(hb.body, topmenu);
        hb.body.addContent(return_value1);
        hb.body.addContent(return_value2);
        hb.body.addContent(return_value3);
        hb.body.addContent(return_value4);

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

    void FormatStatsEredivisie::updateOneResult(teamWithMinMaxResults& result, const int x, const std::string& team)
    {
        if (result.max.teams.empty() || result.max.result < x)
        {
            result.max.result = x;
            result.max.teams = { team };
        }
        else if (result.max.result == x)
        {
            result.max.teams.push_back(team);
        }

        if (result.min.teams.empty() || result.min.result > x)
        {
            result.min.result = x;
            result.min.teams = { team };
        }
        else if (result.min.result == x)
        {
            result.min.teams.push_back(team);
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

    strikingResults FormatStatsEredivisie::getStrikingResults(const football::footballCompetition& competition)
    {
        strikingResults results;
        int maxDiff = 0;
        int maxMax = 0;
        int maxSum = 0;
        for ( const auto& match : competition.matches)
        {
            if (match.team2 == "straf") continue;
            if (match.result == "-") continue;
            const auto parts = readers::csvReader::split(match.result, "-").column;
            const auto goals1 = std::stoi(parts[0]);
            const auto goals2 = std::stoi(parts[1]);

            const auto diff = abs(goals1 - goals2);
            if (diff > maxDiff)
            {
                results.biggestVictory = { match };
                maxDiff = diff;
            }
            else if (diff == maxDiff)
            {
                results.biggestVictory.push_back(match);
            }

            const auto maxGoals = std::max(goals1, goals2);
            if (maxGoals > maxMax)
            {
                results.mostGoalsPerTeam = { match };
                maxMax = maxGoals;
            }
            else if (maxGoals == maxMax)
            {
                results.mostGoalsPerTeam.push_back(match);
            }

            const auto sum = goals1 + goals2;
            if (sum > maxSum)
            {
                results.mostGoalsPerMatch = { match };
                maxSum = sum;
            }
            else if (sum == maxSum)
            {
                results.mostGoalsPerMatch.push_back(match);
            }
        }
        return results;
    }

    std::vector<std::pair<std::string, double>> FormatStatsEredivisie::findExtremeValueInMap(const std::unordered_map<std::string, double>& data, double factor)
    {
        auto return_value = std::vector<std::pair<std::string, double>>();
        for (const auto& x : data)
        {
            if (return_value.empty() || return_value[0].second == x.second)  // NOLINT(clang-diagnostic-float-equal)
            {
                return_value.emplace_back(x);
            }
            else if (return_value[0].second * factor < x.second * factor)
            {
                return_value = { x };
            }

        }
        return return_value;
    }

    spectatorResults FormatStatsEredivisie::getSpectatorStats(const football::footballCompetition& competition)
    {
        spectatorResults results;
        int total = 0;
        int nMatches = 0;
        auto resultsPerTeam = std::unordered_map<std::string, std::pair<int, int>>();
        auto meanSpectatorsPerTeam = std::unordered_map<std::string, double>();
        for (const auto& match : competition.matches)
        {
            if (match.team2 == "straf") continue;
            if (match.result == "-") continue;

            total += match.spectators;
            nMatches++;

            if (results.mostSpectators.empty() || results.mostSpectators[0].spectators < match.spectators)
            {
                results.mostSpectators = { match };
            }
            else if (results.mostSpectators[0].spectators == match.spectators)
            {
                results.mostSpectators.push_back(match);
            }

            if (results.leastSpectators.empty() || results.leastSpectators[0].spectators > match.spectators)
            {
                results.leastSpectators = { match };
            }
            else if (results.leastSpectators[0].spectators == match.spectators)
            {
                results.leastSpectators.push_back(match);
            }

            if (const auto it = resultsPerTeam.find(match.team1); it == resultsPerTeam.end())
            {
                resultsPerTeam.insert({ match.team1, { match.spectators, 1 } });
            }
            else
            {
                it->second.first += match.spectators;
                it->second.second++;
            }
        }

        for (const auto& result : resultsPerTeam)
        {
            meanSpectatorsPerTeam.insert({ result.first, MathSupport::divide(result.second.first, result.second.second) });
        }

        results.totalSpectators = total;
        results.meanSpectators = MathSupport::divide(total, nMatches);
        results.teamsWithMostSpectators = findExtremeValueInMap(meanSpectatorsPerTeam, 1.0);
        results.teamsWithLeastSpectators = findExtremeValueInMap(meanSpectatorsPerTeam, -1.0);
        return results;
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
                summary.goals.max.to_string(), std::format("{:3}", summary.goals.max.result),
                summary.goals.min.to_string(), std::format("{:3}",summary.goals.min.result),
                summary.goals_against.max.to_string(), std::format("{:3}",summary.goals_against.max.result),
                summary.goals_against.min.to_string(), std::format("{:3}",summary.goals_against.min.result),
                summary.difference.max.to_string(), "+" + std::format("{:3}",summary.difference.max.result),
                summary.difference.min.to_string(), std::format("{:3}",summary.difference.min.result)
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

    void FormatStatsEredivisie::getFieldsTable3(const std::vector<football::footballMatch>& matches, std::string& matchNames, std::string& results) const
    {
        for (size_t i = 0; i < matches.size(); i++)
        {
            if (i > 0)
            {
                matchNames += "<br>";
                results += "<br>";
            }
            matchNames += matches[i].matchName(teams);
            results += matches[i].result;
        }
    }

    MultipleStrings FormatStatsEredivisie::table3_to_html(const std::vector<std::pair<Season, strikingResults>>& results) const
    {
        html::tableContent content1;

        if (settings.lang == html::language::English)
        {
            content1.header.data = { "season", "biggest victory", "most goals per team", "most goals per match" };
        }
        else
        {
            content1.header.data = { "seizoen", "ruimste zege", "meeste treffers (&eacute;&eacute;n van beide)", "hoogste totaal" };
        }

        content1.colWidths = { 1, 2, 2, 2 };

        html::tableContent content;
        content.header.data = {};

        for (const auto& result : results)
        {
            const auto& szn = result.first;
            const auto& data = result.second;

            MultipleStrings body;
            body.data = std::vector<std::string>(7);
            body.data[0] = szn.toString();
            getFieldsTable3(data.biggestVictory, body.data[1], body.data[2]);
            getFieldsTable3(data.mostGoalsPerTeam, body.data[3], body.data[4]);
            getFieldsTable3(data.mostGoalsPerMatch, body.data[5], body.data[6]);
            content.body.push_back(body);
        }

        auto Table = html::table(settings);
        Table.id = "id3";
        auto return_value = MultipleStrings();
        return_value.addContent("<p/> <a name=\"extr_uitsl\">");
        auto table = Table.buildTable({ content1, content });
        return_value.addContent(table);
        return return_value;
    }

    MultipleStrings FormatStatsEredivisie::table4a_to_html(const std::vector<std::pair<Season, spectatorResults>>& results) const
    {
        html::tableContent content;

        if (settings.lang == html::language::English)
        {
            content.header.data = { "season", "" };
        }
        else
        {
            content.header.data = { "seizoen", "totaal aantal toeschouwers", "gemiddelde per wedstrijd",
                "hoogste gemiddelde per club", "laagste gemiddelde per club" };
        }

        for (const auto& result : results)
        {
            const auto& szn = result.first;
            const auto& data = result.second;

            MultipleStrings body;
            body.data = std::vector<std::string>(5);
            body.data[0] = szn.toString();
            body.data[1] = std::format("{:4.2f} M", static_cast<double>(data.totalSpectators) * 1e-6);
            body.data[2] = std::format("{:04.1f} k", data.meanSpectators * 1e-3);
            body.data[3] = std::format("{:} {:04.1f} k", teams.expand(data.teamsWithMostSpectators[0].first), data.teamsWithMostSpectators[0].second * 1e-3);
            body.data[4] = std::format("{:} {:3.1f} k", teams.expand(data.teamsWithLeastSpectators[0].first), data.teamsWithLeastSpectators[0].second * 1e-3);
            content.body.push_back(body);
        }

        auto Table = html::table(settings);
        Table.id = "id3";
        auto return_value = MultipleStrings();
        return_value.addContent("<p/> <a name=\"toesch\">");
        auto table = Table.buildTable(content);
        return_value.addContent(table);
        return return_value;
    }
}
