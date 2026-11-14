
#pragma once
#include <string>
#include "FormatEC.h"

namespace shob::pages
{
    class FormatEcBuilder
    {
    public:
        static bool cmpFunc(const std::string& a, const std::string& b);
        static FormatEc build(const std::string& dataFolder, const html::Settings& settings);
    };
}
