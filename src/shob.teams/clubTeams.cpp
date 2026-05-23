
#include "clubTeams.h"
#include "../shob.readers/csvReader.h"
#include "../shob.html/funcs.h"

namespace shob::teams
{
    using namespace shob::readers;

    void clubTeams::InitFromFile(const std::string& filename, clubsOrCountries team_type)
    {
        teamType = team_type;
        auto data = csvReader::readCsvFile(filename);
        Init(data);
    }

    void clubTeams::AddLandCodes(const nationalTeams& national_teams)
    {
        landCodes = national_teams;
    }

    void clubTeams::MergeTeams(const clubTeams& other)
    {
        for (const auto& team : other.clubs)
        {
            clubs.insert(team);
        }
    }

    std::string clubTeams::expand(const std::string& club, const html::addCountryType addCountry) const
    {
        auto expanded = expand(club);
        if (club.size() == 3 || landCodes.empty()) return expanded;
        auto land = club.substr(0, 2);
        if (addCountry != html::addCountryType::notAtAll && land != "NL")
        {
            auto shortName = nationalTeams::shortName(land);
            if (const auto it = landCodes.find(land); it != landCodes.end())
            {
                const auto& fullNameLand = it->second;
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
        const auto positionInString = expanded.find(") (");
        if (positionInString != std::string::npos)
        {
            expanded.replace(positionInString, 3, "; ");
        }
        return expanded;
    }

    std::string clubTeams::expand(const std::string& club) const
    {
        if (club.size() == 3)
        {
            auto nlClub = "NL" + club;
            const auto it1 = clubs.find(nlClub);
            if (it1 != clubs.end()) return it1->second;
            return nlClub;
        }

        const auto it2 = clubs.find(club);
        if (it2 != clubs.end())
        {
            return it2->second;
        }
        return club;
    }

    void clubTeams::Init(const readers::csvContent& data)
    {
        int col = 1;
        if (data.header.column[1].find("code") != std::string::npos) col = 2;
        for (const auto& row : data.body)
        {
            clubs.insert({ row.column[0], row.column[col] });
        }
    }
}
