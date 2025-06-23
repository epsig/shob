
#include "format_ec.h"
#include <iostream>

#include "../shob.football/results2standings.h"
#include "../shob.football/route2finalFactory.h"
#include "../shob.football/filterResults.h"
#include "../shob.general/dateFactory.h"

namespace shob::pages
{
    using namespace shob::football;
    using namespace shob::readers;
    using namespace shob::html;
    using namespace shob::general;

    void format_ec::get_season_stdout(const std::string& season) const
    {
        const auto output = get_season(season);
        for (const auto& row : output.data)
        {
            std::cout << row << std::endl;
        }
    }

    uniqueStrings format_ec::getQualifiers(const std::string& part, const csvContent& data)
    {
        auto parts = uniqueStrings();
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

    uniqueStrings format_ec::getParts(const csvContent& data)
    {
        auto parts = uniqueStrings();
        for (const auto& row : data.body)
        {
            const auto& part = row.column[0];
            parts.insert(part);
        }
        return parts;
    }

    uniqueStrings format_ec::getGroups(const std::string& part, const csvContent& data)
    {
        auto groups = uniqueStrings();
        for ( const auto& row : data.body)
        {
            if (row.column[0] == part && row.column[1].at(0) == 'g')
            {
                groups.insert(row.column[1]);
            }
        }
        return groups;
    }

    void format_ec::readExtras(const std::string& season, wns_ec& wns_cl, rowContent& summary) const
    {
        auto extraU2s = extras.getSeason(season);
        wns_cl.wns_cl = -1;
        wns_cl.scoring = 3; // default since 1995

        std::string summary_key = (settings.lang == language::Dutch ? "summary_NL" : "summary_UK");

        for (const auto& row : extraU2s)
        {
            if (row[0] == "wns_CL")
            {
                auto option = row[1];
                if (dateFactory::allDigits(option))
                {
                    wns_cl.wns_cl = std::stoi(option);
                }
                else
                {
                    auto splitted = csvReader::split(option, ";");
                    for (const auto & part: splitted.column)
                    {
                        auto splitted2 = csvReader::split(part, ":");
                        auto group = "g" + splitted2.column[0];
                        auto wns = splitted2.column[1];
                        wns_cl.groups.insert({ group, std::stoi(wns) });
                    }
                }
            }
            else if (row[0] == summary_key)
            {
                summary.data.push_back(row[1]);
            }
            else if (row[0] == "scoring")
            {
                wns_cl.scoring = std::stoi(row[1]);
            }
        }
    }

    rowContent format_ec::getFirstHalfYear(const std::string& part, const csvContent& data, const wns_ec& wns_cl) const
    {
        auto rows = rowContent();

        const auto qualifiers = getQualifiers(part, data).list();
        for (const auto& qf : qualifiers)
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            filter.filters.push_back({ 1, qf });
            const auto groupsPhase = filterResults::readFromCsvData(data, filter);
            const auto prepTable = groupsPhase.prepareTable(teams, settings);
            auto table = table::buildTable(prepTable);
            rows.addContent(table);
        }

        const auto groups = getGroups(part, data).list();

        for (const auto& group : groups)
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            filter.filters.push_back({ 1, group });
            const auto groupsPhase = filterResults::readFromCsvData(data, filter);
            auto stand = results2standings::u2s(groupsPhase, wns_cl.scoring);
            stand.wns_cl = wns_cl.getWns(group);
            const auto prepTable = stand.prepareTable(teams, settings);
            auto table = table::buildTable(prepTable);
            rows.addContent(table);
            const auto matchesNL = groupsPhase.filterNL();
            const auto prepTable2 = matchesNL.prepareTable(teams, settings);
            auto table2 = table::buildTable(prepTable2);
            rows.addContent(table2);
        }
        return rows;
    }

    rowContent format_ec::get_season(const std::string& season) const
    {
        auto season1 = season;
        season1.replace(4, 1, "_");
        const auto file1 = sportDataFolder + "/europacup/europacup_" + season1 + ".csv";
        const auto csvData = csvReader::readCsvFile(file1);

        wns_ec wns_cl;
        rowContent summary;
        readExtras(season, wns_cl, summary);
        auto out = rowContent();
        out.addContent("<html> <body>");

        if ( ! summary.data.empty())
        {
            if (settings.lang == language::Dutch)
            {
                out.addContent("<h2> Samenvatting Europacup Seizoen " + season + " </h2>");
            }
            else
            {
                out.addContent("<h2> Summary Europa cup season " + season + "</h2>");
            }
            out.addContent(summary);
        }

        const auto ECparts = getParts(csvData).list();
        for (const auto& part : ECparts)
        {
            if (part != "supercup") // TODO
            {
                auto content = getFirstHalfYear(part, csvData, wns_cl);
                out.addContent(content);
                const auto r2f = route2finaleFactory::createEC(csvData, part);
                const auto prepTable = r2f.prepareTable(teams);
                content = table::buildTable(prepTable);
                out.addContent(content);
            }
        }

        out.addContent("</body> </html>");

        return out;
    }

}
