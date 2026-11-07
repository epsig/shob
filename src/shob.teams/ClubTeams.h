#pragma once
#include <string>
#include <map>
#include "../shob.readers/CsvReader.h"
#include "../shob.html/Settings.h"
#include "NationalTeams.h"

namespace shob::teams
{
    enum class ClubsOrCountries
    {
        clubs,
        countries,
        unknownYet,
    };

    class ClubTeams
    {
    public:
        void InitFromFile(const std::string& filename, ClubsOrCountries team_type);
        void AddLandCodes(const NationalTeams& national_teams);
        void MergeTeams(const ClubTeams& other);
        std::string expand(const std::string& club) const;
        std::string expand(const std::string& club, const html::AddCountryType addCountry) const;
        ClubsOrCountries getClubsOrCountries() const { return teamType; }
    private:
        ClubsOrCountries teamType = ClubsOrCountries::unknownYet;
        void Init(const readers::CsvContent& data);
        std::map<std::string, std::string, std::less<>> clubs;
        NationalTeams landCodes;
    };
}
