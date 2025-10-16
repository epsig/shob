
#include "format_voorr_ekwk.h"
#include <format>
#include <iostream>

#include "head_bottum.h"
#include "../shob.football/filterResults.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.football/results2standings.h"

namespace shob::pages
{
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
        auto isWk = year % 4 == 2;
        std::string ekwk = (isWk ? "wk" : "ek");
        auto csvInput = std::format("{}{}{}u.csv", dataSportFolder,ekwk, year);
        std::cout << csvInput << std::endl;

        const auto csvData = readers::csvReader::readCsvFile(csvInput);

        auto filter = football::filterInputList();

        const std::string part = "gG";
        filter.filters.push_back({ 0, part });
        const auto matches = football::filterResults::readFromCsvData(csvData, filter);

        auto adjSettings = html::settings();
        auto prepTable = matches.prepareTable(teams, adjSettings);
        prepTable.title = "Groep Nederland";
        auto Table = html::table(html::settings());
        auto retVal = Table.buildTable(prepTable);

        auto stand = football::results2standings::u2s(matches);
        auto prepTable2 = stand.prepareTable(teams, adjSettings);
        prepTable2.title = "Stand groep Nederland";
        auto table2 = Table.buildTable(prepTable2);
        retVal.addContent(table2);

        int dd = matches.lastDate().toInt();
        auto hb = headBottumInput(dd);
        hb.title = "Voorronde ek/wk";
        std::swap(hb.body, retVal);

        return headBottum::getPage(hb);

    }
}
