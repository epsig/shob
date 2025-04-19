
#include "standings.h"

namespace shob::football
{
    void standings::addResult(const std::string& team1, const std::string& team2, const int goals1, const int goals2)
    {
        addRow(team1, goals1, goals2);
        addRow(team2, goals2, goals1);
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
        if (goals1 == goals2) row.draws++;
        if (goals1 > goals2) row.wins++;
        if (goals1 < goals2) row.losses++;
        row.totalGames++;
        row.goals += goals1;
        row.goalsAgainst += goals2;
    }
}

