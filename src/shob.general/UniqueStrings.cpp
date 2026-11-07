#include "UniqueStrings.h"

namespace shob::general
{
    void UniqueStrings::insert(const std::string& s)
    {
        if (!contains(s))
        {
            myset.push_back(s);
        }
    }

    bool UniqueStrings::contains(const std::string& s) const
    {
        for (const auto& val : myset)
        {
            if (val == s) return true;
        }
        return false;
    }

    std::vector<std::string> UniqueStrings::list() const
    {
        return myset;
    }
}
