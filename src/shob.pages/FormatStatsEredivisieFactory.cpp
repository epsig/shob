
#include "FormatStatsEredivisieFactory.h"

namespace shob::pages
{
    FormatStatsEredivisie FormatStatsEredivisieFactory::build(const std::string& dataFolder, const html::settings& settings)
    {
        auto teams = teams::clubTeams();
        const auto file = dataFolder + "/../clubs.csv";
        teams.InitFromFile(file, teams::clubsOrCountries::clubs);

        auto fmt_stats_eredivisie = FormatStatsEredivisie(dataFolder, teams, settings);
        return fmt_stats_eredivisie;
    }
}
