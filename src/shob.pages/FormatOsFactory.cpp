
#include "FormatOsFactory.h"
#include "../shob.general/glob.h"
#include <algorithm>

namespace shob::pages
{
    using namespace shob::readers;

    bool FormatOsFactory::cmpFunc(const std::string& a, const std::string& b)
    {
        auto num1 = a.substr(2, 4);
        auto num2 = b.substr(2, 4);
        return num1 < num2;
    }

    TopMenu FormatOsFactory::prepareTopMenu(const std::string& dataFolder)
    {
        auto archive = general::glob::list(dataFolder, "OS_[0-9]{4}.csv");
        std::sort(archive.begin(), archive.end(), cmpFunc);

        auto filenames = general::uniqueStrings();
        for (const auto& name : archive)
        {
            const auto shortName = "sport_schaatsen_" + name.substr(0, 7);
            filenames.insert(shortName);
        }

        auto menu = TopMenu(filenames.list(), 'S');

        return menu;
    }

    FormatOs FormatOsFactory::build(const std::string& folder, const html::settings& settings)
    {
        auto remarks = csvAllSeasonsReader();
        remarks.init(folder + "schaatsen_remarks.csv");

        const auto dames = csvReader::readCsvFile(folder + "schaatsersD.csv");
        const auto heren = csvReader::readCsvFile(folder + "schaatsersH.csv");

        auto national_teams = teams::nationalTeams();
        national_teams.InitFromFile(folder + "../landcodes.csv");

        auto menu = prepareTopMenu(folder);

        auto os = FormatOs(folder, remarks, dames, heren, menu, national_teams, settings);
        return os;
    }
}

