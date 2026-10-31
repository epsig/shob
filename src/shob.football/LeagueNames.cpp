
#include "LeagueNames.h"
#include "../shob.readers/csvReader.h"

namespace shob::football
{
    LeagueNames::LeagueNames(const std::string& filename)
    {
        auto leagueNames = readers::csvReader::readCsvFile(filename);
        for (const auto& line : leagueNames.body)
        {
            auto allNames = leagueName();
            allNames.fullName = line.column[1];
            allNames.linkName = line.column[2];
            allNames.shortName = line.column[3];
            data.insert({ line.column[0], allNames });
        }
    }

    std::string LeagueNames::getFullName(const std::string& id) const
    {
        return data.at(id).fullName;
    }

    std::string LeagueNames::getLinkName(const std::string& id) const
    {
        return data.at(id).linkName;
    }

    std::string LeagueNames::getShortName(const std::string& id) const
    {
        return data.at(id).shortName;
    }

    bool LeagueNames::contains(const std::string& id) const
    {
        return data.contains(id);
    }

}
