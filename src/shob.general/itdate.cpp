
#include "itdate.h"

namespace shob::general
{
    std::string itdate ::toString() const
    {
        size_t year;
        size_t day;
        size_t mon;
        if (splitAndValidate(year, mon, day))
        {
            return std::to_string(day) + " " + monthsDutch[mon - 1] + " " + std::to_string(year);
        }
        return std::to_string(dd);
    }

    bool itdate::splitAndValidate(size_t& year, size_t& mon, size_t& day) const
    {
        if (dd < 0) return false;
        year = dd / 10000;
        day = dd % 100;
        mon = (dd - day - 10000 * year) / 100;
        return mon <= 12 && day <= maxDays(year, mon);
    }

    std::string itdate::toShortString() const
    {
        size_t year;
        size_t day;
        size_t mon;
        if (splitAndValidate(year, mon, day))
        {
            return std::to_string(day) + " " + monthsDutch[mon - 1];
        }
        return "*****";
    }
}
