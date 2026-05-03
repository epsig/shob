
#include "FormatStatsEredivisieFactory.h"
#include "../shob.general/glob.h"

namespace shob::pages
{
    FormatStatsEredivisie FormatStatsEredivisieFactory::build(const std::string& dataFolder, const html::settings& settings)
    {
        auto teams = teams::clubTeams();
        const auto file = dataFolder + "/../clubs.csv";
        teams.InitFromFile(file, teams::clubsOrCountries::clubs);

        auto list1 = general::glob::list(dataFolder, "eredivisie_[12][90].*");
        auto list2 = general::glob::list(dataFolder, "eindstand_eredivisie_[12][90].*");

        auto fmt_stats_eredivisie = FormatStatsEredivisie(dataFolder, teams, list1, list2, settings);
        return fmt_stats_eredivisie;
    }
}
