
#include "route2final.h"

namespace shob::football
{
    void route2final::addOneRound(html::tableContent& table, const std::vector<footballMatch>& matches,
        const std::vector<int>& positions, const teams::clubTeams& teams, const size_t offset)
    {
        if (matches.size() == positions.size())
        {
            for(size_t i = 0; i < positions.size(); i++)
            {
                html::rowContent data;
                for (size_t j = 0; j < offset; j++) data.data.emplace_back("");
                data.data.push_back( matches[i].printSimple(teams)) ;
                for (size_t j = offset; j < 4; j++) data.data.emplace_back("");
                table.body[positions[i]] = data;
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

        addOneRound(table, final.matches, lineNrs2, teams, 3);
        addOneRound(table, semiFinal.matches, lineNrs4, teams, 2);
        addOneRound(table, quarterFinal.matches, lineNrs8, teams, 1);
        addOneRound(table, last16.matches, lineNrs16, teams, 0);

        return table;
    }
}


