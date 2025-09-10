
#include "route2final.h"

namespace shob::football
{
    using namespace shob::html;

    void route2final::addOneRound(tableContent& table, const footballCompetition& matches,
        const std::vector<int>& positions, const teams::clubTeams& teams, const size_t offset, const size_t maxCols,
        const settings settings, const std::vector<addCountryType>& addCountry)
    {
        if (matches.matches.size() == positions.size())
        {
            for(size_t i = 0; i < positions.size(); i++)
            {
                general::multipleStrings data;
                for (size_t j = 0; j < offset; j++) data.data.emplace_back("");
                data.data.push_back( matches.matches[i].printSimple(teams, false, settings.isCompatible, addCountry)) ;
                for (size_t j = offset + 1; j < maxCols; j++) data.data.emplace_back("");
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
                        auto first = matches.matches[i].printSimple(teams, false, settings.isCompatible, addCountry);
                        auto ii = returns.couples[i];
                        auto second = matches.matches[ii].printSimple(teams, true, settings.isCompatible, addCountry);
                        data.data.push_back(first + "<br>" + second);
                        for (size_t j = offset + 1; j < maxCols; j++) data.data.emplace_back("");
                        table.body[positions[ipos]] = data;
                        ipos++;
                    }
                }
            }
        }
    }

    tableContent route2final::prepareTable(const teams::clubTeams& teams, const settings& settings) const
    {
        const std::vector lineNrs16 = { 0, 2, 4, 6, 9, 11, 13, 15 };
        std::vector<int> lineNrs8;
        std::vector<int> lineNrs4;
        std::vector<int> lineNrs2;
        std::vector<size_t> offsets;
        int finalTextRow;
        size_t maxCols;

        auto table = tableContent();
        if (!last16.matches.empty())
        {
            lineNrs8 = { 1, 5, 10, 14 };
            lineNrs4 = { 3, 12 };
            lineNrs2 = { 8 };
            table.body = std::vector<general::multipleStrings>(16);
            finalTextRow = 7;
            offsets = { 3,2,1,0 };
            maxCols = 4;
        }
        else
        {
            lineNrs8 = { 0, 2, 5, 7 };
            lineNrs4 = { 1, 6 };
            lineNrs2 = { 4 };
            table.body = std::vector<general::multipleStrings>(8);
            finalTextRow = 3;
            offsets = { 2,1,0 };
            maxCols = 3;
        }

        if ( ! final.matches.empty())
        {
            auto row = general::multipleStrings();
            for (int i = 0; i < (last16.matches.empty() ? 2 : 3); i++)
            {
                row.data.emplace_back("");
            }
            if (settings.lang == language::Dutch)
            {
                row.data.emplace_back("<b>F I N A L E:</b>");
            }
            else
            {
                row.data.emplace_back("<b>F I N A L:</b>");
            }
            table.body[finalTextRow] = row;
        }
        std::vector addCountries1 = { addCountryType::withAcronym, addCountryType::notAtAll };
        std::vector addCountries2 = { addCountryType::notAtAll, addCountryType::notAtAll };
        addOneRound(table, final, lineNrs2, teams, offsets[0], maxCols, settings, addCountries2);
        addOneRound(table, semiFinal, lineNrs4, teams, offsets[1], maxCols, settings, addCountries2);
        if (!last16.matches.empty())
        {
            addOneRound(table, quarterFinal, lineNrs8, teams, offsets[2], maxCols, settings, addCountries2);
            addOneRound(table, last16, lineNrs16, teams, offsets[3], maxCols, settings, addCountries1);
        }
        else
        {
            addOneRound(table, quarterFinal, lineNrs8, teams, offsets[2], maxCols, settings, addCountries1);
        }

        return table;
    }
}


