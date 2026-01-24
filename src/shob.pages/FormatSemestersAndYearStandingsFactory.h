#pragma once

#include "FormatSemestersAndYearStandings.h"
#include "TopMenu.h"

namespace shob::pages
{
    class FormatSemestersAndYearStandingsFactory
    {
    public:
        FormatSemestersAndYearStandings build(const std::string& folder, const html::settings& settings);
    private:
        TopMenu prepareTopMenu(const std::string& dataFolder) const;
        static bool cmpFunc(const std::string& a, const std::string& b);
        static readers::csvContent readMatchesData(const std::string& folder, const general::Season& season);
        void getLastYear(const std::string& folder);
        int last_year = -1;
    };
}

