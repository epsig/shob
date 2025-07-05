
#include "format_ec_factory.h"
#include "topMenu.h"
#include "../shob.general/glob.h"

namespace shob::pages
{
    format_ec format_ec_factory::build(const std::string& dataFolder, const html::settings& settings)
    {
        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(dataFolder + "/europacup/europacup_remarks.csv");

        auto teams = teams::clubTeams();
        auto file2 = dataFolder + "/clubs.csv";
        teams.InitFromFile(file2);

        auto archive = general::glob::list(dataFolder + "/europacup", "europacup_[0-9].*csv");
        auto menu = topMenu(archive);

        auto format = format_ec(dataFolder, remarks, teams, settings, menu);
        return format;
    }
}
