#include "format_ekwk_qf_factory.h"

#include "topMenu.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.general/glob.h"

namespace shob::pages
{
    format_ekwk_qf format_ekwk_qf_factory::build(const std::string& dataFolder, const html::settings& settings)
    {
        auto dataFolderEkWkQf = dataFolder + "/ekwk_qf/";

        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(dataFolderEkWkQf + "ekwk_qf_remarks.csv");

        auto national_teams = teams::clubTeams();
        national_teams.InitFromFile(dataFolder + "/landcodes.csv");

        auto archive = general::glob::list(dataFolderEkWkQf, "[ew]k[0-9]{4}.*csv");
        auto menu = topMenu(archive);

        auto fmt = format_ekwk_qf(dataFolderEkWkQf, national_teams, remarks, settings);

        return fmt;
    }
}
