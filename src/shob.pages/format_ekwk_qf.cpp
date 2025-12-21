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
            std::cout << row << std::endl;
        }
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
        const auto matches_data = read_matches_data(ekwk);

        auto pageBlocks = std::array<pageBlock, 5>();

        pageBlocks[0].data = get_group_nl(ekwk, dd, star, matches_data);
        pageBlocks[0].linkName = "groepNL";
        pageBlocks[0].description = "Stand en uitslagen groep van Nederland";

        auto [nationsLeagueFinals, nationsLeagueGroups] = get_nationsLeague(year, dd);

        std::swap(nationsLeagueFinals, pageBlocks[1].data);
        pageBlocks[1].linkName = "natleaguefinals";
        pageBlocks[1].description = "Finale Nations League";

        std::swap(nationsLeagueGroups, pageBlocks[2].data);
        pageBlocks[2].linkName = "natleague";
        pageBlocks[2].description = "Nations League groepsfase";

        pageBlocks[3].data = get_play_offs(year, dd, matches_data);
        pageBlocks[3].linkName = "playoffs";
        pageBlocks[3].description = "Naar de play-offs";

        pageBlocks[4].data = get_friendlies(year, remarks, dd);
        pageBlocks[4].linkName = "keizersbaard";
        pageBlocks[4].description = "Oefenduels van Oranje";

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

    readers::csvContent format_ekwk_qf::read_matches_data(const ekwk_date& ekwk) const
    {
        const auto csvInput = std::format("{}{}{}u.csv", dataSportFolder, ekwk.shortName(), ekwk.year);
        const auto csvData = readers::csvReader::readCsvFile(csvInput);
        return csvData;
    }

    multipleStrings format_ekwk_qf::get_group_nl(const ekwk_date& ekwk, int& dd, const int star, const readers::csvContent& matches_data) const
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

    multipleStrings format_ekwk_qf::get_play_offs(const ekwk_date& ekwk, int& dd, const readers::csvContent& matches_data) const
    {
        const auto parts = matches_data.getParts();
        const std::string part = parts.list().back();

        multipleStrings retVal;
        if (part == "po")
        {
            auto filter = filterInputList();
            filter.filters.push_back({ 0, part });
            const auto matches = filterResults::readFromCsvData(matches_data, filter);

            dd = std::max(dd, matches.lastDate().toInt());

            auto prepTableMatchesNL = matches.prepareTable(teams, settings);
            prepTableMatchesNL.title = "naar de play-offs";
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
        const auto csvInput = dataSportFolder + "../oefenduels.csv";
        auto competition = footballCompetition();
        competition.readFromCsv(csvInput); // TODO can be done in factory
        int dd1kzb = (year - 2) * 10000 + 700;
        int dd2kzb = year * 10000 + 700;
        for(const auto& key_value : remarks)
        {
            if (key_value[0] == "dd1kzb") dd1kzb = std::atoi(key_value[1].c_str());
            if (key_value[0] == "dd2kzb") dd2kzb = std::atoi(key_value[1].c_str());
        }
        auto date1 = itdate(dd1kzb);
        auto date2 = itdate(dd2kzb);
        const auto filtered = competition.filterDate(date1, date2);

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

}
