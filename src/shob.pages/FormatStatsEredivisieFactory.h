
#pragma once
#include <string>
#include "FormatStatsEredivisie.h"

namespace shob::pages
{
    class FormatStatsEredivisieFactory
    {
    public:
        static FormatStatsEredivisie build(const std::string& dataFolder, const html::settings& settings);
    };
}
