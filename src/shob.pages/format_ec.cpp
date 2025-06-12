
#include "format_ec.h"
#include <iostream>

#include "../shob.football/results2standings.h"
#include "../shob.football/route2finalFactory.h"
#include "../shob.football/filterResults.h"
#include "../shob.general/dateFactory.h"

namespace shob::pages
{
    using namespace shob::football;

    void format_ec::get_season_stdout(const std::string& season) const
    {
        const auto output = get_season(season);
        for (const auto& row : output.data)
        {
            std::cout << row << std::endl;
        }
    }

    general::uniqueStrings format_ec::getQualifiers(const std::string& part, const readers::csvContent& data)
    {
        auto parts = general::uniqueStrings();
        for (const auto& row : data.body)
        {
            const auto& qf = row.column[1];
            if (row.column[0] == part && qf.at(0) != 'g' && !qf.ends_with("f") && !qf.starts_with("x"))
            {
                parts.insert(qf);
            }
        }
        return parts;
    }

    general::uniqueStrings format_ec::getParts(const readers::csvContent& data)
    {
        auto parts = general::uniqueStrings();
        for (const auto& row : data.body)
        {
            const auto& part = row.column[0];
            parts.insert(part);
        }
        return parts;
    }

    general::uniqueStrings format_ec::getGroups(const std::string& part, const readers::csvContent& data)
    {
        auto groups = general::uniqueStrings();
        for ( const auto& row : data.body)
        {
            if (row.column[0] == part && row.column[1].at(0) == 'g')
            {
                groups.insert(row.column[1]);
            }
        }
        return groups;
    }

    int format_ec::readExtras(const std::string& season) const
    {
        auto extraU2s = extras.getSeason(season);
        int wns_cl = -1;
        if (extraU2s.size() > 1)
        {
            if (extraU2s[1][0] == "wns_CL")
            {
                auto option = extraU2s[1][1];
                if (general::dateFactory::allDigits(option))
                {
                    wns_cl = std::stoi(option);
                }
            }
        }
        return wns_cl;
    }

    html::rowContent format_ec::getFirstHalfYear(const std::string& part, const readers::csvContent& data,
        const std::string& season, const int wns_cl) const
    {
        auto rows = html::rowContent();
        constexpr auto settings = html::settings();

        const auto qualifiers = getQualifiers(part, data).list();
        for (const auto& qf : qualifiers)
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            filter.filters.push_back({ 1, qf });
            const auto groupsPhase = filterResults::readFromCsvData(data, filter);
            const auto prepTable = groupsPhase.prepareTable(teams, settings);
            auto table = html::table::buildTable(prepTable);
            rows.addContent(table);
        }

        const auto groups = getGroups(part, data).list();

        for (const auto& group : groups)
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            filter.filters.push_back({ 1, group });
            const auto groupsPhase = filterResults::readFromCsvData(data, filter);
            auto stand = results2standings::u2s(groupsPhase);
            stand.wns_cl = wns_cl;
            const auto prepTable = stand.prepareTable(teams, settings);
            auto table = html::table::buildTable(prepTable);
            rows.addContent(table);
            const auto matchesNL = groupsPhase.filterNL();
            const auto prepTable2 = matchesNL.prepareTable(teams, settings);
            auto table2 = html::table::buildTable(prepTable2);
            rows.addContent(table2);
        }
        return rows;
    }

    html::rowContent format_ec::get_season(const std::string& season) const
    {
        auto season1 = season;
        season1.replace(4, 1, "_");
        const auto file1 = sportDataFolder + "/europacup/europacup_" + season1 + ".csv";
        const auto csvData = readers::csvReader::readCsvFile(file1);

        int wns_cl = readExtras(season);
        auto out = html::rowContent();
        out.addContent("<html> <body>");

        const auto ECparts = getParts(csvData).list();
        for (const auto& part : ECparts)
        {
            if (part != "supercup") // TODO
            {
                auto content = getFirstHalfYear(part, csvData, season, wns_cl);
                out.addContent(content);
                const auto r2f = route2finaleFactory::createEC(csvData, part);
                const auto prepTable = r2f.prepareTable(teams);
                content = html::table::buildTable(prepTable);
                out.addContent(content);
            }
        }

        out.addContent("</body> </html>");

        return out;
    }

}
