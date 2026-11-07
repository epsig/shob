
#include "uniqueStrings.h"

namespace shob::general
{
    void uniqueStrings::insert(const std::string& s)
    {
        if (!contains(s))
        {
            myset.push_back(s);
        }
    }

    bool uniqueStrings::contains(const std::string& s) const
    {
        for (const auto& val : myset)
        {
            if (val == s) return true;
        }
        return false;
    }

    std::vector<std::string> uniqueStrings::list() const
    {
        return myset;
    }
}
