
#include "FormatSemestersAndYearStandings.h"
#include "HeadBottom.h"
#include "../shob.football/footballCompetition.h"
#include "../shob.football/results2standings.h"
#include "../shob.general/glob.h"

#include <format>
#include <filesystem>

namespace shob::pages
{
    namespace fs = std::filesystem;

    int FormatSemestersAndYearStandings::getScoring(const general::Season & season) const
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

    general::MultipleStrings FormatSemestersAndYearStandings::getPages(const int year) const
    {
        auto return_value = general::MultipleStrings();

        auto season1 = general::Season(year - 1);
        auto season2 = general::Season(year);

        const int scoring1 = getScoring(season1);
        const int scoring2 = getScoring(season2);

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
        football::footballCompetition matches2;
        football::footballCompetition matches3;
        if ( ! matches2_csv.body.empty())
        {
            matches2 = football::footballCompetition();
            matches2.readFromCsvData(matches2_csv);
            matches3 = football::footballCompetition();
            matches3.readFromCsvData(all_matches);
        }

        const auto date1 = general::itdate(year * 10000);
        const auto date2 = general::itdate((year + 1) * 10000);
        const auto filtered1 = matches1.filterDate(date1, date2);
        const auto filtered2 = matches2.filterDate(date1, date2);
        const auto filtered3 = matches3.filterDate(date1, date2);
        const auto dd = filtered3.lastDate().toInt();

        const auto stand1 = football::results2standings::u2s(filtered1, scoring1);
        const auto stand2 = football::results2standings::u2s(filtered2, scoring2);
        const auto stand3 = football::results2standings::u2s(filtered3, scoring2);

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

        general::MultipleStrings joined;
        if (matches2_csv.body.empty())
        {
            joined = part1;
        }
        else
        {
            joined = table.tableOfThreeTables(part1, part2, part3);
        }

        auto topMenu = menu.getMenu(std::to_string(year), 29);
        return_value.addContent("<hr> Ga naar andere jaren: ");
        return_value.addContent(topMenu);
        return_value.addContent("<hr>");

        return_value.addContent(joined);

        if (scoring1 != scoring2)
        {
            return_value.addContent("<p/> Opm: puntentelling is halverwege het jaar veranderd. Tabel kalenderjaar rekent met nieuwe telling.");
        }

        auto hb = HeadBottomInput(dd);
        hb.title = "Winterkampioen en jaarstanden eredivisie";
        std::swap(hb.body, return_value);

        return HeadBottom::getPage(hb);
    }

    bool FormatSemestersAndYearStandings::isValidYear(const int year) const
    {
        auto season1 = general::Season(year - 1);
        auto season2 = general::Season(year);
        const auto csv_input1 = std::format("{}/eredivisie_{}.csv", folder, season1.toPartFilename());
        const auto csv_input2 = std::format("{}/eredivisie_{}.csv", folder, season2.toPartFilename());
        auto file1_exists = fs::exists(csv_input1);
        auto file2_exists = fs::exists(csv_input2);

        // if both seasons exist, we have the normal situation:
        if (file1_exists && file2_exists) return true;

        // if season1 does not exist, we are too far back in history:
        if (!file1_exists) return false;

        // now check if there are matches in the current season in the new year:
        // TODO something to cache and/or move to factory
        auto matches = readMatchesData(season1);
        auto competition = football::footballCompetition();
        competition.readFromCsvData(matches);
        auto date = competition.lastDate().toInt();
        auto new_year = date / 10000;

        return new_year == year;
    }

    int FormatSemestersAndYearStandings::getLastYear() const
    {
        // TODO something to cache and/or move to factory
        auto archive = general::glob::list(folder, "eredivisie_[0-9]{4}_[0-9]{4}.csv");
        sortArchive(archive);
        auto last_year_in_filename = archive.back().substr(11, 4); // TODO with regex
        auto last_year = std::stoi(last_year_in_filename);
        auto season = general::Season(last_year);
        auto matches = readMatchesData(season);
        auto competition = football::footballCompetition();
        competition.readFromCsvData(matches);
        auto date = competition.lastDate().toInt();
        auto new_year = date / 10000;
        return new_year;
    }

    readers::csvContent FormatSemestersAndYearStandings::readMatchesData(const general::Season& season) const
    {
        const auto csv_input = std::format("{}/eredivisie_{}.csv", folder, season.toPartFilename());
        const auto csv_data = readers::csvReader::readCsvFile(csv_input);
        return csv_data;
    }

    std::string FormatSemestersAndYearStandings::getOutputFilename(const std::string& output_folder) const
    {
        return std::format("{}/sport_voetbal_nl_jaarstanden.html", output_folder);
    }

    std::string FormatSemestersAndYearStandings::getOutputFilename(const std::string& output_folder, const int year) const
    {
        return std::format("{}/sport_voetbal_nl_jaarstanden_{}.html", output_folder, year);
    }

}

