
#include "format_ec.h"
#include <iostream>
#include <set>

#include "../shob.football/results2standings.h"
#include "../shob.football/route2finalFactory.h"
#include "../shob.football/filterResults.h"

namespace shob::pages
{
    void format_ec::get_season_stdout(const std::string& season) const
    {
        auto output = get_season(season);
        for (const auto& row : output)
        {
            std::cout << row << std::endl;
        }
    }

    std::set<std::string> format_ec::getGroups(const std::string& part, const readers::csvContent& data)
    {
        auto groups = std::set<std::string>();
        for ( const auto& row : data.body)
        {
            if (row.column[0] == part && row.column[1].at(0) == 'g')
            {
                groups.insert(row.column[1]);
            }
        }
        return groups;
    }

    html::rowContent format_ec::getFirstHalfYear(const std::string& part, const readers::csvContent& data) const
    {
        auto rows = html::rowContent();
        auto settings = html::settings();

        auto groups = getGroups(part, data);

        for (const auto& group : groups)
        {
            auto filter = football::filterInputList();
            filter.filters.push_back({ 0, part });
            filter.filters.push_back({ 1, group });
            const auto groupsPhase = football::filterResults::readFromCsvData(data, filter);
            const auto stand = football::results2standings::u2s(groupsPhase);
            const auto prepTable = stand.prepareTable(teams, settings);
            const auto table = html::table::buildTable(prepTable);
            if (rows.data.empty())
            {
                rows = table;
            }
            else
            {
                for (const auto & r : table.data)
                {
                    rows.data.push_back(r);
                }
            }
        }
        return rows;
    }

    std::vector<std::string> format_ec::get_season(const std::string& season) const
    {
        auto season1 = season;
        season1.replace(4, 1, "_");
        auto file1 = sportDataFolder + "/europacup/europacup_" + season1 + ".csv";
        const auto csvData = readers::csvReader::readCsvFile(file1);

        auto out = std::vector<html::rowContent>();

        auto ECparts = { "CL", "EL", "CF" };
        for (const auto& part : ECparts)
        {
            out.push_back(getFirstHalfYear(part, csvData));
            auto r2f = football::route2finaleFactory::createEC(csvData, part);
            const auto prepTable = r2f.prepareTable(teams);
            out.push_back(html::table::buildTable(prepTable));
        }

        std::vector<std::string> output;
        output.emplace_back("<html> <body>");
        for (const auto& part : out)
        {
            for (const auto& row : part.data)
            {
                output.push_back(row);
            }
        }
        output.emplace_back("</body> </html>");

        return output;
    }

}
