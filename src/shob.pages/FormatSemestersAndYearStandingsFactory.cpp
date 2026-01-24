
#include "FormatSemestersAndYearStandingsFactory.h"
#include "../shob.general/glob.h"
#include "../shob.football/footballCompetition.h"

#include <algorithm>
#include <format>

namespace shob::pages
{

    FormatSemestersAndYearStandings FormatSemestersAndYearStandingsFactory::build(const std::string& folder, const html::settings& settings)
    {
        getLastYear(folder);
        auto menu = prepareTopMenu(folder);

        auto teams = teams::clubTeams();
        teams.InitFromFile(folder + "/../clubs.csv", teams::clubsOrCountries::clubs);

        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(folder + "eredivisie_remarks.csv");

        auto format = FormatSemestersAndYearStandings(folder, teams, menu, remarks, last_year, settings);
        return format;
    }

    TopMenu FormatSemestersAndYearStandingsFactory::prepareTopMenu(const std::string& dataFolder) const
    {
        auto archive = general::glob::list(dataFolder, "eredivisie_[0-9]{4}_[0-9]{4}.csv");
        std::sort(archive.begin(), archive.end(), cmpFunc);

        auto filenames = general::uniqueStrings();
        bool is_first = true;
        auto yr = std::to_string(last_year);
        bool found_last_year = false;
        for (const auto& name : archive)
        {
            if (is_first)
            {
                is_first = false;
            }
            else
            {
                const auto shortName = "sport_voetbal_nl_jaarstanden_" + name.substr(11, 4);
                if (shortName.find(yr) != std::string::npos) found_last_year = true;
                filenames.insert(shortName);
            }
        }
        if ( ! found_last_year)
        {
            const auto shortName = "sport_voetbal_nl_jaarstanden_" + yr;
            filenames.insert(shortName);
        }

        auto menu = TopMenu(filenames.list(), 'n');

        return menu;
    }

    bool FormatSemestersAndYearStandingsFactory::cmpFunc(const std::string& a, const std::string& b)
    {
        return a < b;
    }

    readers::csvContent FormatSemestersAndYearStandingsFactory::readMatchesData(const std::string& folder, const general::Season& season)
    {
        const auto csv_input = std::format("{}/eredivisie_{}.csv", folder, season.toPartFilename());
        const auto csv_data = readers::csvReader::readCsvFile(csv_input);
        return csv_data;
    }

    bool cmpFunc2(const std::string& a, const std::string& b)
    {
        return a < b;
    }

    void FormatSemestersAndYearStandingsFactory::getLastYear(const std::string& folder)
    {
        auto archive = general::glob::list(folder, "eredivisie_[0-9]{4}_[0-9]{4}.csv");
        std::sort(archive.begin(), archive.end(), cmpFunc2);
        auto last_year_in_filename = archive.back().substr(11, 4); // TODO with regex
        auto lastyear = std::stoi(last_year_in_filename);
        auto season = general::Season(lastyear);
        auto matches = readMatchesData(folder, season);
        auto competition = football::footballCompetition();
        competition.readFromCsvData(matches);
        auto date = competition.lastDate().toInt();
        last_year = date / 10000;
    }

}

