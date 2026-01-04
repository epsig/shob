
#include "FormatUnOfficialStandings.h"
#include "HeadBottom.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.football/footballCompetition.h"
#include "../shob.football/results2standings.h"

#include <iostream>
#include <format>

namespace shob::pages
{
    void FormatUnOfficialStandings::getPagesToFile(const int year, const std::string& filename) const
    {
        auto output = getPages(year);
        html::updateIfDifferent::update(filename, output);
    }

    void FormatUnOfficialStandings::getPagesStdout(const int year) const
    {
        const auto output = getPages(year);
        for (const auto& row : output.data)
        {
            std::cout << row << '\n';
        }
        std::cout.flush();
    }

    general::MultipleStrings FormatUnOfficialStandings::getPages(const int year) const
    {
        auto return_value = general::MultipleStrings();

        auto season1 = general::Season(year - 1);
        auto season2 = general::Season(year);

        const auto matches1_csv = readMatchesData(season1);
        const auto matches2_csv = readMatchesData(season2);
        auto all_matches = readers::csvContent();
        all_matches.header = matches1_csv.header;
        all_matches.body = matches1_csv.body;
        for (const auto& row : matches2_csv.body)
        {
            // this is tricky: columns may not match; extra columns will be neglected.
            all_matches.body.push_back(row);
        }

        auto matches1 = football::footballCompetition();
        matches1.readFromCsvData(matches1_csv);
        auto matches2 = football::footballCompetition();
        matches2.readFromCsvData(matches2_csv);
        auto matches3 = football::footballCompetition();
        matches3.readFromCsvData(all_matches);

        const auto date1 = general::itdate(year * 10000);
        const auto date2 = general::itdate((year + 1) * 10000);
        const auto filtered1 = matches1.filterDate(date1, date2);
        const auto filtered2 = matches2.filterDate(date1, date2);
        const auto filtered3 = matches3.filterDate(date1, date2);
        const auto dd = filtered3.lastDate().toInt();

        const auto stand1 = football::results2standings::u2s(filtered1);
        const auto stand2 = football::results2standings::u2s(filtered2);
        const auto stand3 = football::results2standings::u2s(filtered3);

        auto prep_table1 = stand1.prepareTable(teams, settings);
        prep_table1.title = "stand 1e helft " + std::to_string(year);
        auto prep_table2 = stand2.prepareTable(teams, settings);
        prep_table2.title = "stand 2e helft " + std::to_string(year);
        auto prep_table3 = stand3.prepareTable(teams, settings);
        prep_table3.title = "kalenderjaar " + std::to_string(year);

        const auto table = html::table(settings);
        auto part1 = table.buildTable(prep_table1);
        auto part2 = table.buildTable(prep_table2);
        auto part3 = table.buildTable(prep_table3);

        auto joined = table.tableOfThreeTables(part1, part2, part3);

        auto topMenu = menu1.getMenu(std::to_string(year), 29);
        return_value.addContent("<hr> Ga naar andere jaren: ");
        return_value.addContent(topMenu);
        return_value.addContent("<hr>");

        return_value.addContent(joined);

        auto hb = HeadBottomInput(dd);
        hb.title = "Winterkampioen en jaarstanden eredivisie";
        std::swap(hb.body, return_value);

        return HeadBottom::getPage(hb);
    }

    readers::csvContent FormatUnOfficialStandings::readMatchesData(const general::Season& season) const
    {
        const auto csv_input = std::format("{}/eredivisie_{}.csv", folder, season.toPartFilename());
        const auto csv_data = readers::csvReader::readCsvFile(csv_input);
        return csv_data;
    }

}

