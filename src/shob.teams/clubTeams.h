
#pragma once
#include <string>
#include <map>
#include "../shob.readers/csvReader.h"
#include "../shob.html/settings.h"
#include "nationalTeams.h"

namespace shob::teams
{
    class clubTeams
    {
    public:
        void InitFromFile(const std::string& filename);
        void AddLandCodes(const nationalTeams& national_teams);
        void MergeTeams(const clubTeams& other);
        std::string expand(const std::string& club) const;
        std::string expand(const std::string& club, const html::addCountryType addCountry) const;
    private:
        void Init(const readers::csvContent& data);
        std::map<std::string, std::string> clubs;
        nationalTeams landCodes;
    };
}
