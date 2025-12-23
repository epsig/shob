#include "format_ekwk_qf.h"
#include "head_bottum.h"
#include "../shob.football/filterResults.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.football/results2standings.h"
#include "../shob.football/route2finalFactory.h"
#include "../shob.general/glob.h"

#include <filesystem>
#include <format>
#include<array>
#include <iostream>

namespace shob::pages
{
    using namespace shob::football;
    using namespace shob::general;
    namespace fs = std::filesystem;

    void format_ekwk_qf::get_pages_to_file(const int year, const std::string& filename) const
    {
        auto output = get_pages(year);
        html::updateIfDifferent::update(filename, output);
    }

    void format_ekwk_qf::get_pages_stdout(const int year) const
    {
        const auto output = get_pages(year);
        for (const auto& row : output.data)
        {
            std::cout << row << '\n';
        }
        std::cout.flush();
    }

    int format_ekwk_qf::findStar(const std::vector<std::vector<std::string>>& remarks)
    {
        for(const auto& remark : remarks)
        {
            if (remark[1].starts_with("star"))
            {
                auto number = remark[1].substr(5, 1);
                return std::atoi(number.c_str());
            }
        }
        return 0;
    }

    multipleStrings format_ekwk_qf::get_pages(const int year) const
    {
        struct pageBlock
        {
            multipleStrings data;
            std::string linkName;
            std::string description;
        };

        const auto ekwk = ekwk_date(year);

        auto remarks = seasonsReader.getSeason(ekwk.shortNameWithYear());
        auto star = findStar(remarks);

        auto retVal = multipleStrings();
        retVal.addContent("<hr>");
        auto topMenu = menu.getMenu(std::to_string(year));
        retVal.addContent(topMenu);
        retVal.addContent("<hr>");

        int dd = 0;
        const auto matches_data = read_matches_data(ekwk, 'u');

        auto pageBlocks = std::array<pageBlock, 8>();

        pageBlocks[0].data = get_group_nl(dd, star, matches_data);
        pageBlocks[0].linkName = "groepNL";
        pageBlocks[0].description = "Stand en uitslagen groep van Nederland";
        const bool EKinBE_NL = pageBlocks[0].data.data.empty();

        auto title = std::format("<h2> {} {}groepen: </h2>", EKinBE_NL ? "Alle":"Overige", ekwk.isWk ? "Europese " : "");
        pageBlocks[1].data = get_other_standings(ekwk, title);
        pageBlocks[1].linkName = "standen";
        pageBlocks[1].description = std::format("Standen {} groepen", EKinBE_NL ? "alle" : "overige");

        auto [nationsLeagueFinals, nationsLeagueGroups] = get_nationsLeague(year, dd);

        std::swap(nationsLeagueFinals, pageBlocks[2].data);
        pageBlocks[2].linkName = "natleaguefinals";
        pageBlocks[2].description = "Finale Nations League";

        std::swap(nationsLeagueGroups, pageBlocks[3].data);
        pageBlocks[3].linkName = "natleague";
        pageBlocks[3].description = "Nations League groepsfase";

        auto opms_vstand = filter_remarks(remarks);
        pageBlocks[4].data = get_virtual_standings(ekwk, opms_vstand);
        pageBlocks[4].linkName = "vstandings";
        pageBlocks[4].description = "Virtuele stand nummers 2";

        pageBlocks[5].data = get_play_offs(dd, matches_data);
        pageBlocks[5].linkName = "playoffs";
        pageBlocks[5].description = "Naar de play-offs";

        const auto title_qualified = std::format("Overzicht deelnemende landen {}-{}", ekwk.shortNameUpper(), year);
        pageBlocks[6].data = get_list_qualified_countries(ekwk, title_qualified);
        pageBlocks[6].linkName = "deelnemers";
        pageBlocks[6].description = title_qualified;

        pageBlocks[7].data = get_friendlies(year, remarks, dd);
        pageBlocks[7].linkName = "keizersbaard";
        pageBlocks[7].description = "Oefenduels van Oranje";

        const auto csvMainTournament = std::format("{}{}{}{}.csv", dataSportFolder, "../ekwk/", ekwk.shortName(), ekwk.year);
        auto submenu = multipleStrings();
        submenu.addContent("<ul>");
        if (fs::exists(csvMainTournament))
        {
            submenu.addContent("<li> <a href=\"../pages/sport_voetbal_" + ekwk.shortNameUpper() + "_" + std::to_string(year)
                + ".html\">Eindronde " + std::to_string(year) + " in " + organizingCountries.at(ekwk.shortNameWithYear()) + "</a> </li>");
        }
        for (const auto& block : pageBlocks)
        {
            if ( ! block.data.data.empty())
            {
                submenu.addContent("<li> <a href=\"#" + block.linkName + "\">" + block.description + "</a> </li>");
            }
        }
        submenu.addContent("</ul> <hr>");

        retVal.addContent(submenu);

        for (auto& block : pageBlocks)
        {
            if ( ! block.data.data.empty())
            {
                retVal.addContent(block.data);
            }
        }

        auto hb = headBottumInput(dd);
        hb.title = "Voorronde " + ekwk.shortNameUpper() + " Voetbal " + std::to_string(year) + " te " + organizingCountries.at(ekwk.shortNameWithYear());
        std::swap(hb.body, retVal);

        return headBottum::getPage(hb);
    }

    multipleStrings format_ekwk_qf::print_splitted(const standings& stand, const footballCompetition& matches, const std::string& title) const
    {
        auto prepTableStandings = stand.prepareTable(teams, settings);
        prepTableStandings.title = title;

        auto splitted = matches.split_matches("NL");

        auto prepTableMatchesNL = splitted.first.prepareTable(teams, settings);
        prepTableMatchesNL.title = "Uitslagen Nederland";
        const auto Table = html::table(settings);
        auto leftPart = Table.buildTable({ prepTableStandings, prepTableMatchesNL });

        auto prepTableMatchesWithoutNL = splitted.second.prepareTable(teams, settings);
        prepTableMatchesWithoutNL.title = "Overige uitslagen";
        auto rightPart = Table.buildTable(prepTableMatchesWithoutNL);

        const auto retVal = Table.tableOfTwoTables(leftPart, rightPart);
        return retVal;
    }

    readers::csvContent format_ekwk_qf::read_matches_data(const ekwk_date& ekwk, const char type) const
    {
        const auto csvInput = std::format("{}{}{}{}.csv", dataSportFolder, ekwk.shortName(), ekwk.year, type);
        const auto csvData = readers::csvReader::readCsvFile(csvInput);
        return csvData;
    }

    multipleStrings format_ekwk_qf::get_group_nl(int& dd, const int star, const readers::csvContent& matches_data) const
    {
        const auto parts = matches_data.getParts();
        const std::string part = parts.list()[0];

        if (part.starts_with("g"))
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            const auto matches = filterResults::readFromCsvData(matches_data, filter);

            dd = matches.lastDate().toInt();

            auto stand = results2standings::u2s(matches);
            stand.wns_cl = star;

            auto retVal = multipleStrings();
            retVal.addContent("<p/> <a name=\"groepNL\"/>");
            auto standing_and_matches = print_splitted(stand, matches, "Stand groep Nederland");
            retVal.addContent(standing_and_matches);
            return retVal;
        }
        dd = 20000101;
        return multipleStrings();
    }

    multipleStrings format_ekwk_qf::filter_remarks(const std::vector<std::vector<std::string>>& remarks)
    {
        auto retVal = multipleStrings();
        for (const auto& row : remarks)
        {
            if (row[0] == "vstand") retVal.addContent(row[1]);
        }
        return retVal;
    }

    multipleStrings format_ekwk_qf::get_virtual_standings(const ekwk_date& ekwk, multipleStrings& opms_vstand) const
    {
        const auto standings_data = read_matches_data(ekwk, 'v');
        auto retVal = multipleStrings();
        if ( ! standings_data.body.empty())
        {
            retVal.addContent("<p/> <a name=\"vstandings\"/>");
            auto standing = standings();
            standing.initFromData(standings_data);
            auto prepTableStandings = standing.prepareTable(teams, settings);
            prepTableStandings.title = "Virtuele stand nummers 2";
            auto table = html::table(settings);
            auto lines = table.buildTable(prepTableStandings);
            retVal.addContent(lines);
            if ( ! opms_vstand.data.empty())
            {
                retVal.addContent("<br/>");
                retVal.addContent(opms_vstand);
            }
        }
        return retVal;
    }

    multipleStrings format_ekwk_qf::get_play_offs(int& dd, const readers::csvContent& matches_data) const
    {
        const auto parts = matches_data.getParts();
        const std::string part = parts.list().back();

        multipleStrings retVal;
        if (part == "po")
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            auto matches = filterResults::readFromCsvData(matches_data, filter);
            matches.doCoupleMatches = false;

            dd = std::max(dd, matches.lastDate().toInt());

            auto prepTableMatchesNL = matches.prepareTable(teams, settings);
            prepTableMatchesNL.title = "Naar de play-offs";
            const auto Table = html::table(settings);
            auto playoffs = Table.buildTable(prepTableMatchesNL);
            retVal.addContent("<p/> <a name=\"playoffs\"/>");
            retVal.addContent(playoffs);
            return retVal;
        }

        return retVal;
    }

    multipleStrings format_ekwk_qf::get_nationsLeagueFinals(const int& year, int& dd) const
    {
        auto retVal = multipleStrings();
        const auto csvInput = std::format("{}{}{}.csv", dataSportFolder, "../nationsLeague/NL_", year);
        if (fs::exists(csvInput))
        {
            const auto finals = route2finaleFactory::create(csvInput);
            auto prepTable = finals.prepareTable(teams, settings);
            prepTable[0].header.addContent("Finals Nations League");
            auto Table = html::table(settings);
            Table.withBorder = false;
            retVal.addContent("<p/> <a name=\"natleaguefinals\"/>");
            auto matches = Table.buildTable(prepTable);
            retVal.addContent(matches);
            dd = std::max(dd, finals.lastDate().toInt());
        }

        return retVal;
    }

    multipleStrings format_ekwk_qf::get_nationsLeagueGroupPhase(const int& year, int& dd) const
    {
        auto retVal = multipleStrings();
        const auto csvInput = std::format("{}{}.*.csv", "NL_", year);
        auto list = glob::list(dataSportFolder + "../nationsLeague/", csvInput);
        if ( ! list.empty())
        {
            auto competition = footballCompetition();
            competition.readFromCsv(dataSportFolder + "../nationsLeague/" + list[0]);

            dd = std::max(dd, competition.lastDate().toInt());

            const auto stand = results2standings::u2s(competition);
            retVal.addContent("<p/> <a name=\"natleague\"/>");
            auto matches = print_splitted(stand, competition, "Stand Nations League groep Nederland");
            retVal.addContent(matches);
        }
        return retVal;
    }

    std::pair<multipleStrings, multipleStrings> format_ekwk_qf::get_nationsLeague(const int& year, int& dd) const
    {
        auto retVal1 = get_nationsLeagueFinals(year - 1, dd);
        auto retVal2 = get_nationsLeagueGroupPhase(year - 2, dd);

        return { retVal1, retVal2 };
    }

    multipleStrings format_ekwk_qf::get_friendlies(const int& year, const std::vector<std::vector<std::string>>& remarks, int& dd) const
    {
        auto retVal = multipleStrings();

        // default dates for start and stop:
        int dd1kzb = (year - 2) * 10000 + 700;
        int dd2kzb = year * 10000 + 700;

        // adjust defaults, needed for postponed EK-2020 (due to Corona)
        for(const auto& key_value : remarks)
        {
            if (key_value[0] == "dd1kzb") dd1kzb = std::atoi(key_value[1].c_str());
            if (key_value[0] == "dd2kzb") dd2kzb = std::atoi(key_value[1].c_str());
        }
        const auto date1 = itdate(dd1kzb);
        const auto date2 = itdate(dd2kzb);
        const auto filtered = allFriendlies.filterDate(date1, date2);

        auto prepTableMatchesNL = filtered.prepareTable(teams, settings);
        if (!prepTableMatchesNL.empty())
        {
            dd = std::max(dd, filtered.lastDate().toInt());
            prepTableMatchesNL.title = "Uitslagen Oefenduels Nederland";
            const auto Table = html::table(settings);
            retVal.addContent("<p/> <a name=\"keizersbaard\"/>");
            auto matches = Table.buildTable(prepTableMatchesNL);
            retVal.addContent(matches);
        }

        return retVal;
    }

    multipleStrings format_ekwk_qf::get_other_standings(const ekwk_date& ekwk, const std::string& title) const
    {
        const auto csvData = read_matches_data(ekwk, 's');

        auto retVal = multipleStrings();
        if ( ! csvData.body.empty())
        {
            retVal.addContent(std::format("<p/> <a name=\"standen\"/> {}", title));
            const auto parts = csvData.getParts();
            auto tables = std::vector<html::tableContent>();
            for (const auto& part : parts.list())
            {
                auto csvStand = readers::csvContent();
                csvStand.header = csvData.header;
                for (auto line : csvData.body)
                {
                    if (line.column[0] == part)
                    {
                        csvStand.body.push_back(line);
                    }
                }
                auto standing = standings();
                standing.initFromData(csvStand);
                auto prepTableStandings = standing.prepareTable(teams, settings);
                prepTableStandings.title = std::format("Groep {}", part[1]);
                tables.push_back(prepTableStandings);
            }
            auto ftable = html::table(settings);
            auto all = ftable.buildTable(tables);
            retVal.addContent(all);
        }

        return retVal;
    }

    multipleStrings format_ekwk_qf::get_list_qualified_countries(const ekwk_date& ekwk, const std::string& title_qualified) const
    {
        const auto csvData = read_matches_data(ekwk, 'q');
        auto retVal = multipleStrings();
        if (!csvData.body.empty())
        {
            retVal.addContent(std::format("<p/> <a name=\"deelnemers\"> <h2> {} </h2>", title_qualified));
            html::tableContent content;
            content.header.data = { "land", "opm" };
            for (const auto& row : csvData.body)
            {
                const auto country = teams.expand(row.column[1]);
                multipleStrings body;
                body.data = { country, row.column[2]};
                content.body.push_back(body);
            }
            const auto Table = html::table(settings);
            auto table = Table.buildTable(content);
            retVal.addContent(table);
        }
        return retVal;
    }

}
