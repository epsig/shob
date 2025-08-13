
#pragma once
#include <string>
#include <map>
#include "../shob.readers/csvReader.h"
#include "../shob.html/settings.h"

namespace shob::teams
{
    class clubTeams
    {
    public:
        void InitFromFile(const std::string& filename);
        void AddLandCodes(const std::string& filename);
        std::string expand(const std::string& club) const;
        std::string expand(const std::string& club, const html::addCountryType addCountry) const;
    private:
        void Init(const readers::csvContent& data);
        std::map<std::string, std::string> clubs;
        std::map<std::string, std::string> landCodes;
    };
}
