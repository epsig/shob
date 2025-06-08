
#include "format_ec_factory.h"

namespace shob::pages
{
    format_ec format_ec_factory::build(const std::string& dataFolder)
    {
        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(dataFolder + "/europacup/europacup_remarks.csv");

        auto teams = teams::clubTeams();
        auto file2 = dataFolder + "/clubs.csv";
        teams.InitFromFile(file2);

        auto format = format_ec(dataFolder, remarks, teams);
        return format;
    }
}
