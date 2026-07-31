
#pragma once
#include <string>
#include "FormatNL.h"

namespace shob::pages
{
    class format_nl_factory
    {
    public:
        static bool cmpFunc(const std::string& a, const std::string& b);
        static FormatNL build(const std::string& dataFolder, const html::settings& settings);
    };
}
