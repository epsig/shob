
#include "route2final.h"

namespace shob::football
{
    void route2final::addOneRound(html::tableContent& table, const footballCompetition& matches,
        const std::vector<int>& positions, const teams::clubTeams& teams, const size_t offset)
    {
        if (matches.matches.size() == positions.size())
        {
            for(size_t i = 0; i < positions.size(); i++)
            {
                html::rowContent data;
                for (size_t j = 0; j < offset; j++) data.data.emplace_back("");
                data.data.push_back( matches.matches[i].printSimple(teams)) ;
                for (size_t j = offset; j < 4; j++) data.data.emplace_back("");
                table.body[positions[i]] = data;
            }
        }
        else
        {
            auto returns = matches.getReturns();
            if (matches.matches.size() -returns.size() == positions.size())
            {
                for (size_t i = 0; i < positions.size(); i++)
                {
                    // TODO only works for final
                    html::rowContent data;
                    for (size_t j = 0; j < offset; j++) data.data.emplace_back("");
                    auto first = matches.matches[i].printSimple(teams);
                    auto ii = returns[i];
                    auto second = matches.matches[ii].printSimple(teams, true);
                    data.data.push_back(first + "<br>" + second);
                    for (size_t j = offset+1; j < 4; j++) data.data.emplace_back("");
                    table.body[positions[i]] = data;
                }
            }
        }
    }

    html::tableContent route2final::prepareTable(const teams::clubTeams& teams) const
    {
        const std::vector lineNrs16 = { 0, 2, 4, 6, 9, 11, 13, 15 };
        const std::vector lineNrs8 = { 1, 5, 10, 14 };
        const std::vector lineNrs4 = { 3, 12};
        const std::vector lineNrs2 = { 8 };

        auto table = html::tableContent();
        table.body = std::vector<html::rowContent>(16);

        if ( ! final.matches.empty())
        {
            auto row = html::rowContent();
            row.data = { "", "", "", "<b>F I N A L E:</b>" };
            table.body[7] = row;
        }
        addOneRound(table, final, lineNrs2, teams, 3);
        addOneRound(table, semiFinal, lineNrs4, teams, 2);
        addOneRound(table, quarterFinal, lineNrs8, teams, 1);
        addOneRound(table, last16, lineNrs16, teams, 0);

        return table;
    }
}


