#pragma once

#include "FormatSemestersAndYearStandings.h"
#include "TopMenu.h"

namespace shob::pages
{
    class FormatSemestersAndYearStandingsFactory
    {
    public:
        static FormatSemestersAndYearStandings build(const std::string& folder, const html::settings& settings);
    private:
        static TopMenu prepareTopMenu(const std::string& dataFolder);
        static bool cmpFunc(const std::string& a, const std::string& b);
    };
}

