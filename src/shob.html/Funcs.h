#pragma once

#include <string>

namespace shob::html
{
    class Funcs
    {
    public:
        static std::string acronym(const std::string& shortName, const std::string& longName);
        static bool isAcronymOnly(const std::string& cell);
    };
}
