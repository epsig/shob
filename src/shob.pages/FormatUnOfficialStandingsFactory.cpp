
#include "FormatUnOfficialStandingsFactory.h"
#include "../shob.general/glob.h"
#include <algorithm>


namespace shob::pages
{

    FormatUnOfficialStandings FormatUnOfficialStandingsFactory::build(const std::string& folder, const html::settings& settings)
    {
        auto menu = prepareTopMenu(folder);
        auto menu2 = prepareTopMenu2(folder);

        auto teams = teams::clubTeams();
        teams.InitFromFile(folder + "/../clubs.csv", teams::clubsOrCountries::clubs);

        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(folder + "eredivisie_remarks.csv");

        auto format = FormatUnOfficialStandings(folder, teams, menu,menu2, remarks, settings);
        return format;
    }

    TopMenu FormatUnOfficialStandingsFactory::prepareTopMenu(const std::string& dataFolder)
    {
        auto archive = general::glob::list(dataFolder, "eredivisie_[0-9]{4}_[0-9]{4}.csv");
        std::sort(archive.begin(), archive.end(), cmpFunc);

        auto filenames = general::uniqueStrings();
        bool is_first = true;
        for (const auto& name : archive)
        {
            if (is_first)
            {
                is_first = false;
            }
            else
            {
                const auto shortName = "sport_voetbal_nl_jaarstanden_" + name.substr(11, 4);
                filenames.insert(shortName);
            }
        }

        auto menu = TopMenu(filenames.list(), 'n');

        return menu;
    }

    TopMenu FormatUnOfficialStandingsFactory::prepareTopMenu2(const std::string& dataFolder)
    {
        auto archive = general::glob::list(dataFolder, "eredivisie_[0-9]{4}_[0-9]{4}.csv");
        std::sort(archive.begin(), archive.end(), cmpFunc);

        auto filenames = general::uniqueStrings();
        bool is_first = true;
        for (const auto& name : archive)
        {
            if (is_first)
            {
                is_first = false;
            }
            else
            {
                const auto shortName = "nl_uit_thuis_" + name.substr(11, 13);
                filenames.insert(shortName);
            }
        }

        auto menu = TopMenu(filenames.list(), 'n');

        return menu;
    }

    bool FormatUnOfficialStandingsFactory::cmpFunc(const std::string& a, const std::string& b)
    {
        return a < b;
    }

}

