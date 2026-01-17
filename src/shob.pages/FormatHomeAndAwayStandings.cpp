
#include "FormatHomeAndAwayStandings.h"
#include "HeadBottom.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.football/footballCompetition.h"
#include "../shob.football/results2standings.h"

#include <format>
#include <filesystem>

namespace shob::pages
{
    namespace fs = std::filesystem;

    void FormatHomeAndAwayStandings::getPagesToFile(const general::Season& season, const std::string& filename) const
    {
        auto output = getSeason(season);
        html::updateIfDifferent::update(filename, output);
    }

    void FormatHomeAndAwayStandings::getPagesStdout(const general::Season& season) const
    {
        const auto output = getSeason(season);
        output.toStdout();
    }

    int FormatHomeAndAwayStandings::getScoring(const general::Season& season) const
    {
        const auto currentRemarks = all_seasons_reader.getSeason(season);
        int scoring = 3;
        for (const auto& row : currentRemarks)
        {
            if (row[0] == "scoring")
            {
                scoring = std::stoi(row[1]);
                break;
            }
        }
        return scoring;
    }

    general::MultipleStrings FormatHomeAndAwayStandings::getSeason(const general::Season& season) const
    {
        auto return_value = general::MultipleStrings();
        const int scoring = getScoring(season);

        const auto matches_csv = readMatchesData(season);

        auto matches = football::footballCompetition();
        matches.readFromCsvData(matches_csv);

        const auto dd = matches.lastDate().toInt();

        auto stand1 = football::standings();
        auto stand2 = football::standings();
        football::results2standings::u2s_home_away(matches, stand1, stand2, scoring);
        const auto stand3 = football::results2standings::u2s(matches, scoring);

        auto prep_table1 = stand1.prepareTable(teams, settings);
        prep_table1.title = "thuis " + season.toString();
        auto prep_table2 = stand2.prepareTable(teams, settings);
        prep_table2.title = "uit " + season.toString();
        auto prep_table3 = stand3.prepareTable(teams, settings);
        prep_table3.title = "uit + thuis " + season.toString();

        const auto table = html::table(settings);
        auto part1 = table.buildTable(prep_table1);
        auto part2 = table.buildTable(prep_table2);
        auto part3 = table.buildTable(prep_table3);

        auto joined = table.tableOfThreeTables(part1, part2, part3);

        auto topMenu = menu.getMenu(season);
        return_value.addContent("<hr> Ga naar andere seizoenen: ");
        return_value.addContent(topMenu);
        return_value.addContent("<hr>");

        return_value.addContent(joined);

        auto hb = HeadBottomInput(dd);
        hb.title = "Uit- en thuis standen eredivisie";
        std::swap(hb.body, return_value);

        return HeadBottom::getPage(hb);
    }

    std::string FormatHomeAndAwayStandings::getOutputFilename(const std::string& folder, const general::Season& season)
    {
        return std::format("{}/sport_voetbal_nl_uit_thuis_{}.html", folder, season.toPartFilename());
    }

    bool FormatHomeAndAwayStandings::isValidSeason(const general::Season& season) const
    {
        const auto csv_input = std::format("{}/eredivisie_{}.csv", folder, season.toPartFilename());
        return fs::exists(csv_input);
    }

    readers::csvContent FormatHomeAndAwayStandings::readMatchesData(const general::Season& season) const
    {
        const auto csv_input = std::format("{}/eredivisie_{}.csv", folder, season.toPartFilename());
        const auto csv_data = readers::csvReader::readCsvFile(csv_input);
        return csv_data;
    }

}

