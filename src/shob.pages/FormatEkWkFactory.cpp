
#include "FormatEkWkFactory.h"

#include <algorithm>

#include "../shob.general/glob.h"

namespace shob::pages
{
    FormatEkWk FormatEkWkFactory::build(const std::string& dataFolder, const html::settings& settings)
    {
        const auto data_folder_ek_wk = dataFolder + "/ekwk/";

        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(dataFolder + "/ekwk/ekwk_remarks.csv");

        auto topScorers = readers::csvAllSeasonsReader();
        topScorers.init(dataFolder + "/ekwk/topscorers_ekwk.csv");

        auto national_teams = teams::clubTeams();
        national_teams.InitFromFile(dataFolder + "/landcodes.csv", teams::clubsOrCountries::countries);

        auto menu = prepareTopMenu(data_folder_ek_wk);

        auto retval = FormatEkWk(dataFolder, national_teams, settings, remarks, topScorers, menu);
        return retval;
    }

    bool FormatEkWkFactory::cmpFunc(const std::string& a, const std::string& b)
    {
        auto num1 = a.substr(2, 4);
        auto num2 = b.substr(2, 4);
        return num1 < num2;
    }

    TopMenu FormatEkWkFactory::prepareTopMenu(const std::string& dataFolderEkWk)
    {
        auto archive = general::glob::list(dataFolderEkWk, "[ew]k[0-9]{4}.csv");
        std::sort(archive.begin(), archive.end(), cmpFunc);

        auto filenames = general::uniqueStrings();
        for (auto& name : archive)
        {
            auto shortName = name.substr(0, 2) + "_" + name.substr(2, 4);
            std::transform(shortName.begin(), shortName.end(), shortName.begin(), ::toupper);
            shortName = "sport_voetbal_" + shortName;
            filenames.insert(shortName);
        }

        auto menu = TopMenu(filenames.list(), 'K');

        return menu;
    }


}
