#pragma once

#include "FormatUnOfficialStandings.h"
#include "TopMenu.h"

namespace shob::pages
{
    class FormatUnOfficialStandingsFactory
    {
    public:
        static FormatUnOfficialStandings build(const std::string& folder, const html::settings& settings);
    private:
        static TopMenu prepareTopMenu(const std::string& dataFolder);
        static TopMenu prepareTopMenu2(const std::string& dataFolder);
        static bool cmpFunc(const std::string& a, const std::string& b);
    };
}

