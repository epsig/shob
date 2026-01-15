#pragma once

#include "FormatHomeAndAwayStandings.h"
#include "TopMenu.h"

namespace shob::pages
{
    class FormatHomeAndAwayStandingsFactory
    {
    public:
        static FormatHomeAndAwayStandings build(const std::string& folder, const html::settings& settings);
    private:
        static TopMenu prepareTopMenu(const std::string& dataFolder);
        static bool cmpFunc(const std::string& a, const std::string& b);
    };
}

