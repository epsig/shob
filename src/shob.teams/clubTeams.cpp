
#include "clubTeams.h"
#include "../shob.readers/csvReader.h"
#include "../shob.html/funcs.h"

namespace shob::teams
{
    using namespace shob::readers;

    void clubTeams::InitFromFile(const std::string& filename)
    {
        auto data = csvReader::readCsvFile(filename);
        Init(data);
    }

    void clubTeams::AddLandCodes(const nationalTeams& national_teams)
    {
        landCodes = national_teams;
    }

    std::string clubTeams::expand(const std::string& club, const html::addCountryType addCountry) const
    {
        auto expanded = expand(club);
        if (club.size() == 3) return expanded;
        auto land = club.substr(0, 2);
        if (addCountry != html::addCountryType::notAtAll && land != "NL")
        {
            auto shortName = nationalTeams::shortName(land);
            if (landCodes.contains(land))
            {
                auto fullNameLand = landCodes.expand(land);
                if (addCountry == html::addCountryType::withAcronym)
                {
                    expanded += " (" + html::funcs::acronym(shortName, fullNameLand) + ")";
                }
                else
                {
                    expanded += " (" + fullNameLand + ")";
                }
            }
            else
            {
                expanded += " (" + shortName + ")";
            }
        }
        return expanded;
    }

    std::string clubTeams::expand(const std::string& club) const
    {
        if (club.size() == 3)
        {
            auto nlClub = "NL" + club;
            return clubs.at(nlClub);
        }
        else if (clubs.contains(club))
        {
            return clubs.at(club);
        }
        return club;
    }

    void clubTeams::Init(const readers::csvContent& data)
    {
        for (const auto& row : data.body)
        {
            clubs.insert({ row.column[0], row.column[1] });
        }
    }
}
