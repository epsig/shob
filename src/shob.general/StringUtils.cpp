
#include "StringUtils.h"

namespace shob::general
{
    // trim from end of string (right)
    std::string StringUtils::rtrim(const std::string& s, const char* t)
    {
        std::string r = s;
        r.erase(r.find_last_not_of(t) + 1);
        return r;
    }

    // trim from beginning of string (left)
    std::string StringUtils::ltrim(const std::string& s, const char* t)
    {
        std::string r = s;
        r.erase(0, r.find_first_not_of(t));
        return r;
    }

    // trim from both ends of string (right then left)
    std::string StringUtils::trim(const std::string& s, const char* t)
    {
        auto trimmed = rtrim(s, t);
        return ltrim(trimmed, t);
    }

}

