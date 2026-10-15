
#pragma once

#include <string>

namespace shob::general
{
    class StringUtils
    {
    public:
        static std::string trim(const std::string& s, const char* t);
        static std::string rtrim(const std::string& s, const char* t);
        static std::string ltrim(const std::string& s, const char* t);
    };

}

