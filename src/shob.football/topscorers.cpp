
#include "topscorers.h"

namespace shob::football
{
    void topscorers::initFromFile(const std::string& season)
    {
        auto data = reader.getSeason(season);

        for (size_t i = 1; i < data.size(); i++)
        {
            const auto& row = data[i];
            auto tp = topscorer();
            tp.rank = std::stoi(row[0]);
            tp.name = row[1];
            tp.club = row[2];
            tp.goals = std::stoi(row[3]);
            list_tp.push_back(tp);
        }
    }

    html::tableContent topscorers::prepareTable(const teams::clubTeams& teams, const html::settings& settings) const
    {
        auto table = html::tableContent();
        if (settings.lang == html::language::Dutch)
        {
            table.header.data = { "positie", "naam (club)", "doelpunten" };
        }
        else
        {
            table.header.data = { "rank", "player (club)", "goals" };
        }
        for (const auto& row : list_tp)
        {
            html::rowContent data;
            auto team = teams.expand(row.club);

            data.data = { std::to_string(row.rank),  row.name + "(" + team + ")", std::to_string(row.goals) };
            table.body.push_back(data);
        }

        return table;
    }

}

