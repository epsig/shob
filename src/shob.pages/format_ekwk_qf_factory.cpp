#include "format_ekwk_qf_factory.h"

#include "topMenu.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.general/glob.h"
#include "../shob.general/uniqueStrings.h"

#include <algorithm>

namespace shob::pages
{
    bool format_ekwk_qf_factory::cmpFunc(const std::string& a, const std::string& b)
    {
        auto num1 = a.substr(2, 4);
        auto num2 = b.substr(2, 4);
        return num1 < num2;
    }

    topMenu format_ekwk_qf_factory::prepareTopMenu(const std::string& dataFolderEkWkQf)
    {
        auto archive = general::glob::list(dataFolderEkWkQf, "[ew]k[0-9]{4}.*csv");
        std::sort(archive.begin(), archive.end(), cmpFunc);

        auto filenames = general::uniqueStrings();
        for (auto & name : archive)
        {
            auto shortName = name.substr(0, 2) + "_" + name.substr(2,4);
            std::transform(shortName.begin(), shortName.end(), shortName.begin(), ::toupper);
            shortName = "sport_voetbal_" + shortName + "_voorronde";
            filenames.insert(shortName);
        }

        auto menu = topMenu(filenames.list());

        return menu;
    }

    format_ekwk_qf format_ekwk_qf_factory::build(const std::string& dataFolder, const html::settings& settings)
    {
        auto dataFolderEkWkQf = dataFolder + "/ekwk_qf/";

        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(dataFolderEkWkQf + "ekwk_qf_remarks.csv");

        auto national_teams = teams::clubTeams();
        national_teams.InitFromFile(dataFolder + "/landcodes.csv");

        auto menu = prepareTopMenu(dataFolderEkWkQf);

        auto fmt = format_ekwk_qf(dataFolderEkWkQf, national_teams, remarks, settings, menu);

        return fmt;
    }
}
