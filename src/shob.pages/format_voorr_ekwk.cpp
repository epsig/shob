
#include "format_voorr_ekwk.h"
#include <format>
#include <iostream>

#include "head_bottum.h"
#include "../shob.football/filterResults.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.football/results2standings.h"

namespace shob::pages
{
    using namespace shob::football;

    void format_voorr_ekwk::get_pages_to_file(const int year, const std::string& filename) const
    {
        auto output = get_pages(year);
        html::updateIfDifferent::update(filename, output);
    }

    void format_voorr_ekwk::get_pages_stdout(const int year) const
    {
        const auto output = get_pages(year);
        for (const auto& row : output.data)
        {
            std::cout << row << std::endl;
        }
    }

    general::multipleStrings format_voorr_ekwk::get_pages(const int year) const
    {
        const auto ekwk = ekwk_date(year);

        int dd = 0;
        auto retVal = get_group_nl(ekwk, dd);

        auto hb = headBottumInput(dd);
        hb.title = "Voorronde " + ekwk.shortName() + " " + std::to_string(year);
        std::swap(hb.body, retVal);

        return headBottum::getPage(hb);
    }

    general::multipleStrings format_voorr_ekwk::get_group_nl(const ekwk_date& ekwk, int& dd) const
    {
        const auto csvInput = std::format("{}{}{}u.csv", dataSportFolder, ekwk.shortName(), ekwk.year);
        const auto csvData = readers::csvReader::readCsvFile(csvInput);

        auto filter = filterInputList();
        const std::string part = "gG";
        filter.filters.push_back({ 0, part });
        const auto matches = filterResults::readFromCsvData(csvData, filter);

        const auto adjSettings = html::settings();

        auto stand = results2standings::u2s(matches);
        auto prepTableStandings = stand.prepareTable(teams, adjSettings);
        prepTableStandings.title = "Stand groep Nederland";

        auto splitted = matches.split_matches("NL");

        auto prepTableMatchesNL = splitted.first.prepareTable(teams, adjSettings);
        prepTableMatchesNL.title = "Uitslagen Nederland";
        const auto Table = html::table(html::settings());
        auto leftPart = Table.buildTable({ prepTableStandings, prepTableMatchesNL });

        auto prepTableMatchesWithoutNL = splitted.second.prepareTable(teams, adjSettings);
        prepTableMatchesWithoutNL.title = "Overige uitslagen";
        auto rightPart = Table.buildTable(prepTableMatchesWithoutNL);

        auto retVal = general::multipleStrings();
        retVal.addContent("<table border>");
        retVal.addContent("<tr><td valign=""top"">");
        retVal.addContent(leftPart);
        retVal.addContent("</td> <td valign=""top""> ");
        retVal.addContent(rightPart);
        retVal.addContent("</td> </tr>");

        dd = matches.lastDate().toInt();

        return retVal;
    }

}
