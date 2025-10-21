#include "format_ekwk_qf_factory.h"

namespace shob::pages
{
    format_ekwk_qf format_ekwk_qf_factory::build(const std::string& dataFolder, const html::settings& settings)
    {
        auto national_teams = teams::clubTeams();
        national_teams.InitFromFile(dataFolder + "/landcodes.csv");

        auto fmt = format_ekwk_qf(dataFolder + "/ekwk_qf/", national_teams);
        //fmt.get_pages_to_file(year, std::format("../pages_new/voorronde_{}.html", year));
        return fmt;

    }
}
