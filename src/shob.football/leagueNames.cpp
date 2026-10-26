
#include "leagueNames.h"
#include "../shob.readers/csvReader.h"

namespace shob::football
{
    leagueNames::leagueNames(const std::string& filename)
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

    std::string leagueNames::getFullName(const std::string& id) const
    {
        return data.at(id).fullName;
    }

    std::string leagueNames::getLinkName(const std::string& id) const
    {
        return data.at(id).linkName;
    }

    std::string leagueNames::getShortName(const std::string& id) const
    {
        return data.at(id).shortName;
    }

    bool leagueNames::contains(const std::string& id) const
    {
        return data.contains(id);
    }

}
