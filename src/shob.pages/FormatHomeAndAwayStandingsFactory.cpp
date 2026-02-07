
#include "FormatHomeAndAwayStandingsFactory.h"
#include "../shob.general/glob.h"
#include <algorithm>

namespace shob::pages
{
    FormatHomeAndAwayStandings FormatHomeAndAwayStandingsFactory::build(const std::string& folder, const html::settings& settings)
    {
        auto menu = prepareTopMenu(folder);

        auto teams = teams::clubTeams();
        teams.InitFromFile(folder + "/../clubs.csv", teams::clubsOrCountries::clubs);

        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(folder + "eredivisie_remarks.csv");

        auto format = FormatHomeAndAwayStandings(folder, teams, menu, remarks, settings);
        return format;
    }

    TopMenu FormatHomeAndAwayStandingsFactory::prepareTopMenu(const std::string& dataFolder)
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

    bool FormatHomeAndAwayStandingsFactory::cmpFunc(const std::string& a, const std::string& b)
    {
        return a < b;
    }

}

