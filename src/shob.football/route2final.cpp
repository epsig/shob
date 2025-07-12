
#include "route2final.h"

namespace shob::football
{
    using namespace shob::html;

    void route2final::addOneRound(tableContent& table, const footballCompetition& matches,
        const std::vector<int>& positions, const teams::clubTeams& teams, const size_t offset)
    {
        if (matches.matches.size() == positions.size())
        {
            for(size_t i = 0; i < positions.size(); i++)
            {
                general::multipleStrings data;
                for (size_t j = 0; j < offset; j++) data.data.emplace_back("");
                data.data.push_back( matches.matches[i].printSimple(teams)) ;
                for (size_t j = offset + 1; j < 4; j++) data.data.emplace_back("");
                table.body[positions[i]] = data;
            }
        }
        else
        {
            auto returns = matches.getReturns();
            if (matches.matches.size() -returns.couples.size() == positions.size())
            {
                size_t ipos = 0; // counter for positions
                for (size_t i = 0; i < matches.matches.size(); i++)
                {
                    if ( ! returns.isSecondMatch[i])
                    {
                        general::multipleStrings data;
                        for (size_t j = 0; j < offset; j++) data.data.emplace_back("");
                        auto first = matches.matches[i].printSimple(teams);
                        auto ii = returns.couples[i];
                        auto second = matches.matches[ii].printSimple(teams, true);
                        data.data.push_back(first + "<br>" + second);
                        for (size_t j = offset + 1; j < 4; j++) data.data.emplace_back("");
                        table.body[positions[ipos]] = data;
                        ipos++;
                    }
                }
            }
        }
    }

    tableContent route2final::prepareTable(const teams::clubTeams& teams, const language& language) const
    {
        const std::vector lineNrs16 = { 0, 2, 4, 6, 9, 11, 13, 15 };
        const std::vector lineNrs8 = { 1, 5, 10, 14 };
        const std::vector lineNrs4 = { 3, 12};
        const std::vector lineNrs2 = { 8 };

        auto table = tableContent();
        table.body = std::vector<general::multipleStrings>(16);

        if ( ! final.matches.empty())
        {
            auto row = general::multipleStrings();
            if (language == language::Dutch)
            {
                row.data = { "", "", "", "<b>F I N A L E:</b>" };
            }
            else
            {
                row.data = { "", "", "", "<b>F I N A L:</b>" };
            }
            table.body[7] = row;
        }
        addOneRound(table, final, lineNrs2, teams, 3);
        addOneRound(table, semiFinal, lineNrs4, teams, 2);
        addOneRound(table, quarterFinal, lineNrs8, teams, 1);
        addOneRound(table, last16, lineNrs16, teams, 0);

        return table;
    }
}


