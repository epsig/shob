
#include "FormatEC_Factory.h"
#include "TopMenu.h"
#include "../shob.general/glob.h"

namespace shob::pages
{
    FormatEC FormatEC_Factory::build(const std::string& dataFolder, const html::settings& settings)
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
        auto menu = TopMenu(archive, 'K');

        auto leagueNames = football::leagueNames(dataFolder + "/europacup/league_names.csv", settings.isCompatible);

        auto format = FormatEC(dataFolder, remarks, teams, settings, menu, leagueNames);
        return format;
    }
}
