
#pragma once
#include <string>
#include <map>
#include "../shob.readers/csvReader.h"
#include "../shob.html/settings.h"
#include "nationalTeams.h"

namespace shob::teams
{
    enum class clubsOrCountries
    {
        clubs,
        countries,
        unknownYet,
    };

    class clubTeams
    {
    public:
        void InitFromFile(const std::string& filename, clubsOrCountries team_type);
        void AddLandCodes(const nationalTeams& national_teams);
        void MergeTeams(const clubTeams& other);
        std::string expand(const std::string& club) const;
        std::string expand(const std::string& club, const html::addCountryType addCountry) const;
        clubsOrCountries getClubsOrCountries() const { return teamType; }
    private:
        clubsOrCountries teamType = clubsOrCountries::unknownYet;
        void Init(const readers::csvContent& data);
        std::map<std::string, std::string> clubs;
        nationalTeams landCodes;
    };
}
