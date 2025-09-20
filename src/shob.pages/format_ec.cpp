
#include "format_ec.h"
#include <iostream>

#include "head_bottum.h"
#include "../shob.football/results2standings.h"
#include "../shob.football/route2finalFactory.h"
#include "../shob.football/filterResults.h"
#include "../shob.general/dateFactory.h"
#include "../shob.html/updateIfNewer.h"

namespace shob::pages
{
    using namespace shob::football;
    using namespace shob::readers;
    using namespace shob::html;
    using namespace shob::general;

    void format_ec::get_season_to_file(const season& season, const std::string& filename) const
    {
        auto output = get_season(season);
        updateIfDifferent::update(filename, output);
    }

    void format_ec::get_season_stdout(const season& season) const
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
            if (row.column[0] == part && qf.at(0) != 'g' && !qf.ends_with("f") && !qf.starts_with("x") && !qf.starts_with("r"))
            {
                parts.insert(qf);
            }
        }
        return parts;
    }

    uniqueStrings format_ec::getXtra(const std::string& part, const csvContent& data)
    {
        auto parts = uniqueStrings();
        for (const auto& row : data.body)
        {
            const auto& qf = row.column[1];
            if (row.column[0] == part && (qf == "xr" || qf == "8f" || qf == "16f" || qf.starts_with("round")))
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

    std::vector<std::vector<std::string>> format_ec::readExtras(const season& season, wns_ec& wns_cl, multipleStrings& summary) const
    {
        std::vector<std::vector<std::string>> extraU2s = extras.getSeason(season);
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
        return extraU2s;
    }

    multipleStrings format_ec::getSupercup(const csvContent& data) const
    {
        auto filter = filterInputList();
        const std::string part = "supercup";
        filter.filters.push_back({ 0, part });
        const auto matches = filterResults::readFromCsvData(data, filter);
        auto adjSettings = settings;
        adjSettings.addCountry = addCountryType::withAcronym;
        auto prepTable = matches.prepareTable(teams, adjSettings);
        prepTable.title = "Europese Supercup";
        auto Table = table(settings);
        return Table.buildTable(prepTable);
    }

    std::string format_ec::getRemarks(const std::string& part, const std::string& group, const std::vector<std::vector<std::string>>& extraU2s)
    {
        std::string remarks;
        std::string key = "remark_" + part + "_" + group;
        for (const auto& row : extraU2s)
        {
            if (row[0] == key)
            {
                if (!remarks.empty())
                {
                    remarks += "\n";
                }
                remarks += row[1];
            }
        }
        return remarks;
    }

    multipleStrings format_ec::getFirstHalfYear(const std::string& part, const csvContent& data, const wns_ec& wns_cl,
        const std::vector<std::vector<std::string>>& extraU2s) const
    {
        auto tables = std::vector<tableContent>();

        auto adjSettings = settings;
        adjSettings.addCountry = addCountryType::fullCountryName;

        // formatting depends on presence / absence of groups
        const auto groups = getGroups(part, data).list();

        const auto qualifiers = getQualifiers(part, data).list();
        for (const auto& qf : qualifiers)
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            filter.filters.push_back({ 1, qf });
            auto matches = filterResults::readFromCsvData(data, filter);
            if (qf == "intertoto") matches = matches.filterNL();
            if (groups.empty()) matches.onlyKO = true;
            auto prepTable = matches.prepareTable(teams, adjSettings);
            if (qf == "po")
            {
                prepTable.title = "Play-offs " + leagueNames.getFullName(part);
            }
            else if (qf == "itoto")
            {
                prepTable.title = "Intertoto: laatste zestien";
            }
            else if (qf == "intertoto")
            {
                prepTable.title = "Finale Intertoto";
                if (settings.isCompatible) prepTable.title += " (winnaars naar UEFA-cup)";
            }
            else
            {
                prepTable.title = "xe voorronde " + leagueNames.getFullName(part);
                prepTable.title.front() = qf.back();
            }
            tables.push_back(prepTable);
        }

        for (const auto& group : groups)
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            filter.filters.push_back({ 1, group });
            const auto groupsPhase = filterResults::readFromCsvData(data, filter);
            auto stand = results2standings::u2s(groupsPhase, wns_cl.scoring);
            stand.wns_cl = wns_cl.getWns(part, group, groupsPhase);
            auto prepTable = stand.prepareTable(teams, adjSettings);
            if (group.find('2') == std::string::npos)
            {
                prepTable.title = leagueNames.getFullName(part) + ", Groep " + group.back();
            }
            else
            {
                prepTable.title = "Tweede ronde, Poule ";
                prepTable.title += group.back();
            }
            const auto matchesNL = groupsPhase.filterNL();
            const auto prepTable2 = matchesNL.prepareTable(teams, settings);
            tables.push_back(prepTable);
            auto remarks = getRemarks(part, group, extraU2s);
            if ( ! remarks.empty())
            {
                auto prepTable3 = tableContent();
                prepTable3.colWidths.push_back(4);
                auto ms = multipleStrings();
                ms.addContent(remarks);
                prepTable3.body.push_back(ms);
                tables.push_back(prepTable3);
            }
            tables.push_back(prepTable2);
        }

        const auto xtras = getXtra(part, data).list();
        int rounds = 0;
        for (const auto& qf : xtras)
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            filter.filters.push_back({ 1, qf });
            auto matches = filterResults::readFromCsvData(data, filter).filterNL();
            if (groups.empty()) matches.onlyKO = true;
            if ( ! matches.matches.empty())
            {
                auto prepTable = matches.prepareTable(teams, adjSettings);
                if (qf == "xr")
                {
                    prepTable.title = "Tussenronde " + leagueNames.getFullName(part);
                }
                else if (qf.starts_with("round"))
                {
                    prepTable.title = "xe ronde " + leagueNames.getShortName(part);
                    prepTable.title.front() = qf.back();
                    rounds++;
                }
                else if (qf == "16f")
                {
                    if (groups.empty() && rounds == 1)
                    {
                        rounds++;
                        prepTable.title = "2e ronde " + leagueNames.getShortName(part);
                    }
                    else
                    {
                        prepTable.title = "16e finale " + leagueNames.getFullName(part);
                    }
                }
                else
                {
                    prepTable.title = "8-ste finale " + leagueNames.getFullName(part);
                }
                tables.push_back(prepTable);
            }
        }

        auto Table = table(settings);
        return Table.buildTable(tables);
    }

    bool format_ec::hasFinal(const std::string& part, const csvContent& csvData)
    {
        for (const auto& line : csvData.body)
        {
            if (line.column[0] == part && line.column[1].find("f") != std::string::npos)
            {
                return true;
            }
        }
        return false;
    }

    multipleStrings format_ec::getInternalLinks(const std::vector<std::string>& ECparts, const csvContent& csvData) const
    {
        auto out = multipleStrings();
        bool isFirst = true;
        for (const auto& part : ECparts)
        {
            if (leagueNames.contains(part))
            {
                if (part != "supercup")
                {
                    auto link1 = " | <a href=\"#" + leagueNames.getLinkName(part) + "\">" + leagueNames.getFullName(part) + "</a>";
                    if (isFirst)
                    {
                        link1 = "<hr>" + link1;
                        isFirst = false;
                    }
                    out.addContent(link1);
                    if (hasFinal(part, csvData))
                    {
                        auto link2 = " | <a href=\"#" + leagueNames.getLinkName(part) + "_last8\">Finale " + leagueNames.getShortName(part) + "</a>";
                        out.addContent(link2);
                    }
                }
            }
        }
        out.data.back() += " | <hr>";
        return out;
    }

    multipleStrings format_ec::get_season(const season& season) const
    {
        const auto file1 = sportDataFolder + "/europacup/europacup_" + season.to_part_filename() + ".csv";
        const auto csvData = csvReader::readCsvFile(file1);

        wns_ec wns_cl;
        multipleStrings summary;
        auto extraU2s = readExtras(season, wns_cl, summary);
        auto out = multipleStrings();
        auto menuOut = menu.getMenu(season);

        std::string title;
        if (settings.lang == language::Dutch)
        {
            title = "Europacup voetbal seizoen " + season.to_string();
            menuOut.data[0] = "<hr> andere seizoenen: | " + menuOut.data[0];
        }
        else
        {
            title = "Europa cup football season " + season.to_string();
            menuOut.data[0] = "<hr> other seasons: | " + menuOut.data[0];
        }

        out.addContent(menuOut);

        const auto ECparts = getParts(csvData).list();
        auto internalMenu = getInternalLinks(ECparts, csvData);
        out.addContent(internalMenu);

        if ( ! summary.data.empty())
        {
            if (settings.lang == language::Dutch)
                out.addContent("<h2>Samenvatting Europacup Seizoen " + season.to_string() + "</h2>");
            else
                out.addContent("<h2>Summary Europa cup season " + season.to_string() + "</h2>");
            out.addContent(summary);
            out.addContent("<hr>");
        }

        int dd = 0;
        for (const auto& part : ECparts)
        {
            if (part == "supercup")
            {
                auto sc = getSupercup(csvData);
                out.addContent(sc);
            }
            else
            {
                out.addContent("<a name=\"" + leagueNames.getLinkName(part) + "\"/>");
                auto content = getFirstHalfYear(part, csvData, wns_cl, extraU2s);
                out.addContent(content);
                const auto r2f = route2finaleFactory::createEC(csvData, part);
                auto prepTable = r2f.prepareTable(teams, settings);
                prepTable[0].header.addContent(leagueNames.getFullName(part) + ": de laatste acht");
                auto Table = table(settings);
                Table.withBorder = false;
                content = Table.buildTable(prepTable);
                if (settings.isCompatible)
                {
                    out.addContent("<p><a name=\"" + leagueNames.getLinkName(part) + "_last8\"></a><p>");
                }
                else
                {
                    out.addContent("<p><a name=\"" + leagueNames.getLinkName(part) + "_last8\"/>");
                }
                out.addContent(content);
                dd = std::max(dd, r2f.lastDate().toInt());
            }
        }

        auto hb = headBottumInput(dd);
        std::swap(hb.title, title);
        std::swap(hb.body, out);

        return headBottum::getPage(hb);
    }

}
