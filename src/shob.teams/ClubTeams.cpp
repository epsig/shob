#include "ClubTeams.h"
#include "../shob.readers/CsvReader.h"
#include "../shob.html/Funcs.h"

namespace shob::teams
{
    using namespace shob::readers;

    void ClubTeams::InitFromFile(const std::string& filename, ClubsOrCountries team_type)
    {
        teamType = team_type;
        auto data = CsvReader::readCsvFile(filename);
        Init(data);
    }

    void ClubTeams::AddLandCodes(const NationalTeams& national_teams)
    {
        landCodes = national_teams;
    }

    void ClubTeams::MergeTeams(const ClubTeams& other)
    {
        for (const auto& team : other.clubs)
        {
            clubs.insert(team);
        }
    }

    std::string ClubTeams::expand(const std::string& club, const html::AddCountryType addCountry) const
    {
        auto expanded = expand(club);
        if (club.size() == 3 || landCodes.empty()) return expanded;
        auto land = club.substr(0, 2);
        if (addCountry != html::AddCountryType::notAtAll && land != "NL")
        {
            auto shortName = NationalTeams::shortName(land);
            if (const auto it = landCodes.find(land); it != landCodes.end())
            {
                const auto& fullNameLand = it->second;
                if (addCountry == html::AddCountryType::withAcronym)
                {
                    expanded += " (" + html::Funcs::acronym(shortName, fullNameLand) + ")";
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

    std::string ClubTeams::expand(const std::string& club) const
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

    void ClubTeams::Init(const readers::CsvContent& data)
    {
        int col = 1;
        if (data.header.column[1].find("code") != std::string::npos) col = 2;
        for (const auto& row : data.body)
        {
            clubs.insert({ row.column[0], row.column[col] });
        }
    }
}
