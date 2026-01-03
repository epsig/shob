#include "format_ekwk_qf_factory.h"

#include "TopMenu.h"
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

    TopMenu format_ekwk_qf_factory::prepareTopMenu(const std::string& dataFolderEkWkQf)
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

        auto menu = TopMenu(filenames.list(), 'K');

        return menu;
    }

    format_ekwk_qf format_ekwk_qf_factory::build(const std::string& dataFolder, const html::settings& settings)
    {
        auto dataFolderEkWkQf = dataFolder + "/ekwk_qf/";

        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(dataFolderEkWkQf + "ekwk_qf_remarks.csv");

        auto remarksMainTournement = readers::csvAllSeasonsReader();
        remarksMainTournement.init(dataFolder + "/ekwk/ekwk_remarks.csv");
        auto organizingCountries = remarksMainTournement.getAll("organising_country");

        auto national_teams = teams::clubTeams();
        national_teams.InitFromFile(dataFolder + "/landcodes.csv", teams::clubsOrCountries::countries);

        auto teams = teams::clubTeams();
        teams.InitFromFile(dataFolder + "/clubs.csv", teams::clubsOrCountries::unknownYet);
        national_teams.MergeTeams(teams);

        auto menu = prepareTopMenu(dataFolderEkWkQf);

        const auto csvInput = dataFolder + "/oefenduels.csv";
        auto allFriendlies = football::footballCompetition();
        allFriendlies.readFromCsv(csvInput);

        auto fmt = format_ekwk_qf(dataFolderEkWkQf, national_teams, remarks, settings, menu, organizingCountries, allFriendlies);

        return fmt;
    }
}
