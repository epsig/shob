
#include "format_ec.h"
#include <iostream>
#include <set>

#include "../shob.football/results2standings.h"
#include "../shob.football/route2finalFactory.h"
#include "../shob.football/filterResults.h"

namespace shob::pages
{
    using namespace shob::football;

    void format_ec::get_season_stdout(const std::string& season) const
    {
        const auto output = get_season(season);
        for (const auto& row : output)
        {
            std::cout << row << std::endl;
        }
    }

    std::vector<std::string> format_ec::getQualifiers(const std::string& part, const readers::csvContent& data)
    {
        auto partsUnordered = std::vector<std::string>();
        auto partsOrdered = std::set<std::string>();
        for (const auto& row : data.body)
        {
            const auto& qf = row.column[1];
            if (row.column[0] == part && qf.at(0) != 'g' && !qf.ends_with("f") && !qf.starts_with("x"))
            {
                if ( ! partsOrdered.contains(qf))
                {
                    partsUnordered.push_back(qf);
                    partsOrdered.insert(qf);
                }
            }
        }
        return partsUnordered;
    }

    std::vector<std::string> format_ec::getParts(const readers::csvContent& data)
    {
        auto partsUnordered = std::vector<std::string>();
        auto partsOrdered = std::set<std::string>();
        for (const auto& row : data.body)
        {
            const auto& part = row.column[0];
            if ( ! partsOrdered.contains(part))
            {
                partsOrdered.insert(part);
                partsUnordered.push_back(part);
            }
        }
        return partsUnordered;
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
        constexpr auto settings = html::settings();

        const auto qualifiers = getQualifiers(part, data);
        for (const auto& qf : qualifiers)
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            filter.filters.push_back({ 1, qf });
            const auto groupsPhase = filterResults::readFromCsvData(data, filter);
            const auto prepTable = groupsPhase.prepareTable(teams, settings);
            const auto table = html::table::buildTable(prepTable);
            rows.addContent(table);
        }

        const auto groups = getGroups(part, data);

        for (const auto& group : groups)
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            filter.filters.push_back({ 1, group });
            const auto groupsPhase = filterResults::readFromCsvData(data, filter);
            const auto stand = results2standings::u2s(groupsPhase);
            const auto prepTable = stand.prepareTable(teams, settings);
            const auto table = html::table::buildTable(prepTable);
            rows.addContent(table);
            const auto matchesNL = groupsPhase.filterNL();
            const auto prepTable2 = matchesNL.prepareTable(teams, settings);
            const auto table2 = html::table::buildTable(prepTable2);
            rows.addContent(table2);
        }
        return rows;
    }

    std::vector<std::string> format_ec::get_season(const std::string& season) const
    {
        auto season1 = season;
        season1.replace(4, 1, "_");
        const auto file1 = sportDataFolder + "/europacup/europacup_" + season1 + ".csv";
        const auto csvData = readers::csvReader::readCsvFile(file1);

        auto out = std::vector<html::rowContent>();

        const auto ECparts = getParts(csvData);
        for (const auto& part : ECparts)
        {
            if (part != "supercup") // TODO
            {
                out.push_back(getFirstHalfYear(part, csvData));
                const auto r2f = route2finaleFactory::createEC(csvData, part);
                const auto prepTable = r2f.prepareTable(teams);
                out.push_back(html::table::buildTable(prepTable));
            }
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
