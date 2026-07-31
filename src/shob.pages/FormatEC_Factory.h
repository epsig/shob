
#pragma once
#include <string>
#include "FormatEC.h"

namespace shob::pages
{
    class FormatEC_Factory
    {
    public:
        static bool cmpFunc(const std::string& a, const std::string& b);
        static FormatEC build(const std::string& dataFolder, const html::settings& settings);
    };
}
