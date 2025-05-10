
#include "standings.h"

#include <algorithm>

#include "../shob.readers/csvReader.h"

namespace shob::football
{
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
        for (size_t i = 1; i < stand.size(); i++)
        {
            auto row = standingsRow();
            auto& rowCsv = stand[i];
            row.team = rowCsv[0];
            row.totalGames = std::stoi(rowCsv[1]);
            row.points = std::stoi(rowCsv[5]);
            row.goals = std::stoi(rowCsv[6]);
            row.goalsAgainst = std::stoi(rowCsv[7]);
            if ( ! rowCsv[8].empty())
            {
                u2sExtra data;
                data.extras = readers::csvReader::split(rowCsv[8], ";");
                extras.insert({ row.team, data });
            }
            list.push_back(row);
        }
    }

    void standings::addResult(const std::string& team1, const std::string& team2, const int goals1, const int goals2)
    {
        addRow(team1, goals1, goals2);
        addRow(team2, goals2, goals1);  // NOLINT(readability-suspicious-call-argument)
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

    void standings::addRow(const std::string& team, const int goals1, const int goals2)
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
            row.points += 3; // TODO
        }
        else
        {
            row.losses++;
        }
        row.totalGames++;
        row.goals += goals1;
        row.goalsAgainst += goals2;
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

    void standings::sort()
    {
        std::sort(list.begin(), list.end(),
            [](const standingsRow& val1, const standingsRow& val2)
            {return val1.compareTo(val2); });
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
                extra2 = extraData[1];
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
        team += " (" + joinStrings(extra1, extra2, "; ") + ")";

    }

    html::tableContent standings::prepareTable(const teams::clubTeams& teams, const html::settings& settings) const
    {
        auto table = html::tableContent();
        if (settings.lang == html::language::Dutch)
        {
            table.header.data = { "club", "aantal wedstrijden", "punten", "doelsaldo" };
        }
        else
        {
            table.header.data = { "club", "games", "points", "goal difference" };
        }
        for (const auto& row : list)
        {
            html::rowContent data;
            auto team = teams.expand(row.team);
            std::vector<std::string> extraData;
            if (extras.contains(row.team))
            {
                extraData = extras.at(row.team).extras;
            }
            if (row.punishmentPoints != 0 || !extraData.empty())
            {
                updateTeamWithExtras(team, extraData, row.punishmentPoints);
            }

            data.data = { team, std::to_string(row.totalGames), std::to_string(row.points), std::to_string(row.goalDifference()) };
            table.body.push_back(data);
        }

        return table;
    }

    void standings::addExtras(const readers::csvAllSeasonsReader& r, const std::string& season)
    {
        auto extraU2s = r.getSeason(season);
        for (size_t i = 1; i < extraU2s.size(); i++)
        {
            auto teams = extraU2s[i][0];
            auto splittedTeams = readers::csvReader::split(teams, ";");
            auto u2s = extraU2s[i][1];
            u2sExtra data;
            data.extras = readers::csvReader::split(u2s, ";");
            for (const auto& team : splittedTeams)
            {
                extras.insert({ team, data });
            }
        }
    }

}

