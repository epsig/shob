
#include "format_ec_factory.h"
#include "topmenu.h"
#include "../shob.general/glob.h"

namespace shob::pages
{
    format_ec format_ec_factory::build(const std::string& dataFolder, const html::settings& settings)
    {
        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(dataFolder + "/europacup/europacup_remarks.csv");

        auto national_teams = teams::nationalTeams();
        national_teams.InitFromFile(dataFolder + "/landcodes.csv");

        auto teams = teams::clubTeams();
        auto file2 = dataFolder + "/clubs.csv";
        teams.InitFromFile(file2, teams::clubsOrCountries::clubs);
        teams.AddLandCodes(national_teams);

        auto archive = general::glob::list(dataFolder + "/europacup", "europacup_[0-9].*csv");
        auto menu = topMenu(archive, 'K');

        auto leagueNames = football::leagueNames(dataFolder + "/europacup/league_names.csv", settings.isCompatible);

        auto format = format_ec(dataFolder, remarks, teams, settings, menu, leagueNames);
        return format;
    }
}
