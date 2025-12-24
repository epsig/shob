
#include "standings.h"

#include <algorithm>
#include <format>
#include <iostream>

#include "../shob.general/shobException.h"
#include "../shob.readers/csvReader.h"
#include "../shob.html/funcs.h"

namespace shob::football
{
    using namespace shob::general;

    standings::standings()
    {
        // TODO in cvs ; add full descriptions; add English ; remove NP and ND
        mapExtra.insert({ "PDD", "NC;degr." });
        mapExtra.insert({ "PDP", "NC;prom." });
        mapExtra.insert({ "PD", "NC" });
        mapExtra.insert({ "RP", "prom." });
        mapExtra.insert({ "RD", "degr." });
        mapExtra.insert({ "vEL", "voorr. EL" });
        mapExtra.insert({ "vCL", "voorr. CL" });
        mapExtra.insert({ "vCF", "voorr. CF" });
        mapExtra.insert({ "EC2", "ECII" });
        mapExtra.insert({ "NP", "prom." });
        mapExtra.insert({ "ND", "degr." });
    }

    void standings::initFromFile(const std::string& filename)
    {
        auto stand = readers::csvReader::readCsvFile(filename);
        if ( ! stand.body.empty())
        {
            initFromData(stand);
        }
    }

    void standings::initFromData(const readers::csvContent& stand)
    {
        const auto clubNames = stand.findColumnNamesTeams();
        const auto teamColumn = stand.findColumn(clubNames[0]);
        const auto matchesColumn = stand.findColumn("matches");
        const auto pointsColumn = stand.findColumn("points");
        const auto goalsScoredColumn = stand.findColumn("goals_scored");
        const auto goalsAgainstColumn = stand.findColumn("goals_against");
        const auto remarksColumn = stand.findColumn("remark");
        const auto winsColumn = stand.findColumn("wins");
        const auto drawsColumn = stand.findColumn("draws");
        const auto lossesColumn = stand.findColumn("losses");

        for (const auto& col : stand.body)
        {
            auto row = standingsRow();
            auto& rowCsv = col.column;
            row.team = rowCsv[teamColumn];
            row.totalGames = std::stoi(rowCsv[matchesColumn]);
            row.points = std::stoi(rowCsv[pointsColumn]);
            row.goals = std::stoi(rowCsv[goalsScoredColumn]);
            row.goalsAgainst = std::stoi(rowCsv[goalsAgainstColumn]);
            if (winsColumn < rowCsv.size())
            {
                row.wins = std::stoi(rowCsv[winsColumn]);
            }
            else
            {
                row.wins = -1;
            }
            if (drawsColumn < rowCsv.size())
            {
                row.draws = std::stoi(rowCsv[drawsColumn]);
            }
            else
            {
                row.draws = -1;
            }
            if (lossesColumn < rowCsv.size())
            {
                row.losses = std::stoi(rowCsv[lossesColumn]);
            }
            else
            {
                row.losses = -1;
            }
            if (remarksColumn < rowCsv.size() && !rowCsv[remarksColumn].empty())
            {
                u2sExtra data;
                data.extras = readers::csvReader::split(rowCsv[remarksColumn], ";").column;
                extras.insert({ row.team, data });
            }
            list.push_back(row);
        }
    }

    void standings::addResult(const std::string& team1, const std::string& team2, const int goals1, const int goals2)
    {
        addRow(team1, goals1, goals2, false);
        addRow(team2, goals2, goals1, true);  // NOLINT(readability-suspicious-call-argument)
    }

    size_t standings::findIndex(const std::string& team)
    {
        for (size_t i = 0; i < list.size(); i++)
        {
            if (list[i].team == team) return i;
        }
        auto row = standingsRow();
        row.team = team;
        list.push_back(row);
        return list.size() - 1;
    }

    void standings::addRow(const std::string& team, const int goals1, const int goals2, const bool switched)
    {
        auto index = findIndex(team);
        auto& row = list[index];
        if (goals1 == goals2)
        {
            row.draws++;
            row.points++;
        }
        else if (goals1 > goals2)
        {
            row.wins++;
            if (switched) row.awayWins++;
            row.points += scoring;
        }
        else
        {
            row.losses++;
        }
        row.totalGames++;
        row.goals += goals1;
        row.goalsAgainst += goals2;
        if (switched) row.awayGoals += goals1;
    }

    void standings::handlePunishment(const std::string team, const int pnts)
    {
        auto index = findIndex(team);
        auto& row = list[index];
        row.points -= pnts;
        row.punishmentPoints += pnts;
    }

    bool standingsRow::compareTo(const standingsRow& other) const
    {
        if (mutualResults.contains(other.team)) return mutualResults.at(other.team);

        if (points == other.points)
        {
            if (totalGames == other.totalGames)
            {
                return goalDifference() > other.goalDifference();
            }
            else
            {
                return totalGames < other.totalGames;
            }
        }
        else
        {
            return points > other.points;
        }
    }

    bool standingsRow::compareTo6(const standingsRow& other) const
    {
        auto results = std::vector<std::pair<int,int>>();
        results.emplace_back(points, other.points);
        results.emplace_back(-totalGames, -other.totalGames);
        results.emplace_back(goalDifference(), other.goalDifference());
        results.emplace_back(goals, other.goals);
        results.emplace_back(awayGoals, other.awayGoals);
        results.emplace_back(wins, other.wins);
        results.emplace_back(awayWins, other.awayWins);
        results.emplace_back(sumPointsOpponents, other.sumPointsOpponents);
        results.emplace_back(sumGoalDiffOpponents, other.sumGoalDiffOpponents);
        results.emplace_back(sumGoalsOpponents, other.sumGoalsOpponents);

        for (const auto& r : results)
        {
            if (r.first != r.second) return r.first > r.second;
        }
        std::cout << "fall back on comparing teams: " << team << " , " << other.team << std::endl;

        return team < other.team;
    }

    void standings::addNecessaryMutualResults(const std::vector<compactMatch>& matches)
    {
        for (int i=0; i < static_cast<int>(list.size()); i++)
        {
            for (int j=0; j < i; j++)
            {
                if (list[i].points == list[j].points && list[i].totalGames == list[j].totalGames && list[i].totalGames > 0)
                {
                    auto goals = std::vector<int>(2, 0);
                    auto goalsAway = std::vector<int>(2, 0);
                    for (const auto& m : matches)
                    {
                        if (list[i].team == m.team1 && list[j].team == m.team2)
                        {
                            goals[0] += m.goals1;
                            goals[1] += m.goals2;
                            goalsAway[1] += m.goals2;
                        }
                        else if (list[i].team == m.team2 && list[j].team == m.team1)
                        {
                            goals[0] += m.goals2;
                            goals[1] += m.goals1;
                            goalsAway[0] += m.goals2;
                        }
                    }
                    if (goals[0] > goals[1] || (goals[0] == goals[1] && goalsAway[0] > goalsAway[1]))
                    {
                        list[i].mutualResults.insert({ list[j].team, true });
                        list[j].mutualResults.insert({ list[i].team, false });
                    }
                    else if (goals[0] < goals[1] || (goals[0] == goals[1] && goalsAway[0] < goalsAway[1]))
                    {
                        list[i].mutualResults.insert({ list[j].team, false });
                        list[j].mutualResults.insert({ list[i].team, true });
                    }
                }
            }
        }
    }

    size_t standings::findIndex(const std::string& team) const
    {
        for (size_t i = 0; i < list.size(); i++)
        {
            if (list[i].team == team) return i;
        }
        throw shobException("Team not found");
    }

    void standings::addResultsOpponents(const std::vector<compactMatch>& matches)
    {
        for (auto & row : list)
        {
            for (const auto& m : matches)
            {
                size_t index;
                if (m.team1 == row.team)
                {
                    index = findIndex(m.team2);
                }
                else if (m.team2 == row.team)
                {
                    index = findIndex(m.team1);
                }
                else
                {
                    continue;
                }
                row.sumPointsOpponents += list[index].points;
                row.sumGoalDiffOpponents += list[index].goalDifference();
                row.sumGoalsOpponents += list[index].goals;
            }
        }
    }

    void standings::sort(const int sort_rule)
    {
        if (sort_rule == 6)
        {
            std::sort(list.begin(), list.end(),
                [](const standingsRow& val1, const standingsRow& val2)
                {return val1.compareTo6(val2); });
        }
        else
        {
            std::sort(list.begin(), list.end(),
                [](const standingsRow& val1, const standingsRow& val2)
                {return val1.compareTo(val2); });
        }
    }

    std::string joinStrings(const std::string& s1, const std::string& s2, const std::string& separator)
    {   // TODO move to string utils or something like that
        if (s1.empty()) return s2;
        if (s2.empty()) return s1;
        return s1 + separator + s2;
    }

    void standings::expandExtra(std::string& extra) const
    {
        if (mapExtra.contains(extra)) extra = mapExtra.at(extra);
    }

    void standings::updateTeamWithExtras(std::string& team, const std::vector<std::string>& extraData, const int punishment) const
    {
        bool useBold = false;
        std::string extra1;
        std::string extra2;
        if (punishment != 0)
        {
            extra1 = std::to_string(-punishment);
        }
        if ( ! extraData.empty())
        {
            if (extraData[0] == "K")
            {
                useBold = true;
                if (extraData.size() > 1)
                {
                    extra2 = extraData[1];
                }
            }
            else
            {
                extra2 = extraData[0];
            }
            expandExtra(extra2);
        }
        if (useBold)
        {
            team = "<b>" + team + "</b>";
        }
        auto all_extras = joinStrings(extra1, extra2, "; ");
        if (all_extras == "+" || all_extras == "*" || all_extras == "-")
        {
            team += " " + all_extras;
        }
        else
        {
            team += " (" + joinStrings(extra1, extra2, "; ") + ")";
        }
    }

    void standings::updateTeamWithWnsCl(std::string& team, const size_t i) const
    {
        if (wns_cl == 1)
        {
            if (i < 2) team += " +";
        }
        else if (wns_cl == 3)
        {
            if (i < 1) team += " +";
        }
        else if (wns_cl == 4)
        {
            if (i < 1) team += " +";
            else if (i < 2) team += " *";
        }
        else if (wns_cl == 5)
        {
            if (i < 3) team += " +";
        }
        else if (wns_cl == 6)
        {
            if (i < 1) team += " *";
            else if (i < 2) team += " **";
            else if (i < 3) team += " ***";
        }
        else if (wns_cl == 7)
        {
            if (i < 8) team += " *";
            else if (i < 24) team += " +";
        }
        else if (wns_cl == 2)
        {
            if (i < 2) team += " +";
            else if (i < 3) team += " *";
        }
    }

    html::tableContent standings::prepareTable(const teams::clubTeams& teams, const html::settings& settings) const
    {
        auto table = html::tableContent();
        if (settings.lang == html::language::Dutch)
        {
            table.header.data = { "club", "wedstrijden", "punten", "doelsaldo" };
        }
        else
        {
            table.header.data = { "club", "games", "points", "goal difference" };
        }
        if (teams.getClubsOrCountries() == teams::clubsOrCountries::countries)
        {
            table.header.data[0] = "land";
        }

        if (settings.isCompatible) table.header.data.clear();
        for (size_t i = 0; i < list.size(); i++)
        {
            const auto& row = list[i];
            multipleStrings data;
            auto team = teams.expand(row.team, settings.addCountry);
            std::vector<std::string> extraData;
            if (extras.contains(row.team))
            {
                extraData = extras.at(row.team).extras;
            }
            const auto punishmentPoints = settings.isCompatible ?  0: row.punishmentPoints;
            if (punishmentPoints != 0 || !extraData.empty())
            {
                updateTeamWithExtras(team, extraData, punishmentPoints);
            }
            updateTeamWithWnsCl(team, i);

            std::string points;
            if (row.wins >= 0 && row.draws >= 0 && row.losses >= 0)
            {
                points = html::funcs::acronym(std::to_string(row.points),
                    std::format("{:} x w, {:} x g en {:} x v => {:} pnt", row.wins, row.draws, row.losses, row.points));
            }
            else
            {
                points = std::format("{}", row.points);
            }
            std::string goalDiff;
            if (row.goalDifference() == 0)
            {
                goalDiff = html::funcs::acronym(std::format("{0:}", row.goalDifference()),
                    std::format("{:} - {:} = {:}", row.goals, row.goalsAgainst, row.goalDifference()));
            }
            else
            {
                goalDiff = html::funcs::acronym(std::format("{0:+}", row.goalDifference()),
                    std::format("{:} - {:} = {:+}", row.goals, row.goalsAgainst, row.goalDifference()));
            }
            data.data = { team, std::to_string(row.totalGames), points, goalDiff };
            table.body.push_back(data);
        }

        return table;
    }

    void standings::addExtras(const readers::csvAllSeasonsReader& r, const general::season& season)
    {
        const auto extraU2s = r.getSeason(season);
        for (size_t i = 1; i < extraU2s.size(); i++)
        {
            auto teams = extraU2s[i][0];
            auto splittedTeams = readers::csvReader::split(teams, ";").column;
            auto u2s = extraU2s[i][1];
            u2sExtra data;
            data.extras = readers::csvReader::split(u2s, ";").column;
            for (const auto& team : splittedTeams)
            {
                extras.insert({ team, data });
            }
        }
    }

}

