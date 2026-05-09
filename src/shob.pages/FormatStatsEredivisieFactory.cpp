
#include "FormatStatsEredivisieFactory.h"
#include "../shob.general/glob.h"
#include <algorithm>

namespace shob::pages
{
    FormatStatsEredivisie FormatStatsEredivisieFactory::build(const std::string& dataFolder, const html::settings& settings)
    {
        auto teams = teams::clubTeams();
        const auto file = dataFolder + "/../clubs.csv";
        teams.InitFromFile(file, teams::clubsOrCountries::clubs);

        auto fileSummary = StatFilesSummary();

        fileSummary.list_matches = general::glob::list(dataFolder, "eredivisie_[12][90].*");
        fileSummary.list_standings = general::glob::list(dataFolder, "eindstand_eredivisie_[12][90].*");

        std::sort(fileSummary.list_matches.begin(), fileSummary.list_matches.end(),
            [](const std::string& val1, const std::string& val2) {return val1 < val2; });
        std::sort(fileSummary.list_standings.begin(), fileSummary.list_standings.end(),
            [](const std::string& val1, const std::string& val2) {return val1 < val2; });

        fileSummary.last_year_matches = std::stoi(fileSummary.list_matches.back().substr(11, 4));
        fileSummary.first_year_matches = std::stoi(fileSummary.list_matches.front().substr(11, 4));

        if (!fileSummary.list_standings.empty())
        {
            fileSummary.first_year_standings = std::stoi(fileSummary.list_standings.front().substr(21, 4));
        }

        auto fmt_stats_eredivisie = FormatStatsEredivisie(dataFolder, teams, fileSummary, settings);
        return fmt_stats_eredivisie;
    }
}
