
#include "standings.h"

#include <algorithm>

namespace shob::football
{
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


}

