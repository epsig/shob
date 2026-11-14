#pragma once
#include <string>
#include "FormatNL.h"

namespace shob::pages
{
    class FormatNlBuilder
    {
    public:
        static bool cmpFunc(const std::string& a, const std::string& b);
        static FormatNl build(const std::string& dataFolder, const html::Settings& settings);
    };
}
