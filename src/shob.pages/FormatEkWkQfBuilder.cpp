#include "FormatEkWkQfBuilder.h"

#include "TopMenu.h"
#include "../shob.readers/CsvAllSeasonsReader.h"
#include "../shob.general/Glob.h"
#include "../shob.general/UniqueStrings.h"

#include <algorithm>

namespace shob::pages
{
    bool FormatEkWkQfBuilder::cmpFunc(const std::string& a, const std::string& b)
    {
        const auto num1 = a.substr(2, 4);
        const auto num2 = b.substr(2, 4);
        return num1 < num2;
    }

    TopMenu FormatEkWkQfBuilder::prepareTopMenu(const std::string& dataFolderEkWkQf)
    {
        auto archive = general::Glob::list(dataFolderEkWkQf, "[ew]k[0-9]{4}.*csv");
        std::sort(archive.begin(), archive.end(), cmpFunc);

        auto filenames = general::UniqueStrings();
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

    FormatEkWkQf FormatEkWkQfBuilder::build(const std::string& dataFolder, const html::Settings& settings)
    {
        auto dataFolderEkWkQf = dataFolder + "/ekwk_qf/";

        auto remarks = readers::CsvAllSeasonsReader();
        remarks.init(dataFolderEkWkQf + "ekwk_qf_remarks.csv");

        auto remarksMainTournement = readers::CsvAllSeasonsReader();
        remarksMainTournement.init(dataFolder + "/ekwk/ekwk_remarks.csv");
        auto organizingCountries = remarksMainTournement.getAll("organising_country");

        auto national_teams = teams::ClubTeams();
        national_teams.InitFromFile(dataFolder + "/landcodes.csv", teams::ClubsOrCountries::countries);

        auto teams = teams::ClubTeams();
        teams.InitFromFile(dataFolder + "/clubs.csv", teams::ClubsOrCountries::unknownYet);
        national_teams.MergeTeams(teams);

        auto menu = prepareTopMenu(dataFolderEkWkQf);

        const auto csvInput = dataFolder + "/oefenduels.csv";
        auto allFriendlies = football::FootballCompetition();
        allFriendlies.readFromCsv(csvInput);

        auto fmt = FormatEkWkQf(dataFolderEkWkQf, national_teams, remarks, settings, menu, organizingCountries, allFriendlies);

        return fmt;
    }
}
