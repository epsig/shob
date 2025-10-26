#include "format_ekwk_qf.h"
#include "head_bottum.h"
#include "../shob.football/filterResults.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.football/results2standings.h"
#include "../shob.football/footballCompetition.h"

#include <format>
#include <iostream>

namespace shob::pages
{
    using namespace shob::football;

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

    general::multipleStrings format_ekwk_qf::get_pages(const int year) const
    {
        const auto ekwk = ekwk_date(year);

        auto remarks = seasonsReader.getSeason(ekwk.shortNameWithYear());
        auto star = findStar(remarks);

        auto retVal = general::multipleStrings();
        retVal.addContent("<hr>");
        auto topMenu = menu.getMenu(std::to_string(year));
        retVal.addContent(topMenu);
        retVal.addContent("<hr>");

        int dd = 0;
        auto groupNL = get_group_nl(ekwk, dd, star);
        retVal.addContent(groupNL);

        auto hb = headBottumInput(dd);
        hb.title = "Voorronde " + ekwk.shortNameUpper() + " Voetbal " + std::to_string(year) + " te " + organizingCountries.at(ekwk.shortNameWithYear());
        std::swap(hb.body, retVal);

        return headBottum::getPage(hb);
    }

    general::multipleStrings format_ekwk_qf::get_group_nl(const ekwk_date& ekwk, int& dd, const int star) const
    {
        const auto csvInput = std::format("{}{}{}u.csv", dataSportFolder, ekwk.shortName(), ekwk.year);
        const auto csvData = readers::csvReader::readCsvFile(csvInput);

        auto filter = filterInputList();
        const auto parts = csvData.getParts();
        const std::string part = parts.list()[0];

        filter.filters.push_back({ 0, part });
        const auto matches = filterResults::readFromCsvData(csvData, filter);

        auto stand = results2standings::u2s(matches);
        stand.wns_cl = star;
        auto prepTableStandings = stand.prepareTable(teams, settings);
        prepTableStandings.title = "Stand groep Nederland";

        auto splitted = matches.split_matches("NL");

        auto prepTableMatchesNL = splitted.first.prepareTable(teams, settings);
        prepTableMatchesNL.title = "Uitslagen Nederland";
        const auto Table = html::table(settings);
        auto leftPart = Table.buildTable({ prepTableStandings, prepTableMatchesNL });

        auto prepTableMatchesWithoutNL = splitted.second.prepareTable(teams, settings);
        prepTableMatchesWithoutNL.title = "Overige uitslagen";
        auto rightPart = Table.buildTable(prepTableMatchesWithoutNL);

        dd = matches.lastDate().toInt();

        auto retVal = Table.tableOfTwoTables(leftPart, rightPart);
        return retVal;
    }

}
