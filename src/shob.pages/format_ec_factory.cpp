
#include "format_ec_factory.h"

namespace shob::pages
{
    format_ec format_ec_factory::build(const std::string& dataFolder)
    {
        auto extras = readers::csvAllSeasonsReader();
        extras.init(dataFolder + "/europacup/europacup_u2s.csv");

        auto teams = teams::clubTeams();
        auto file2 = dataFolder + "/clubs.csv";
        teams.InitFromFile(file2);

        auto format = format_ec(dataFolder, extras, teams);
        return format;
    }
}
