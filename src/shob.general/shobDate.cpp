
#include "shobDate.h"

namespace shob::general
{
    bool shobDate:: isLeapYear(const size_t year)
    {
        // use definitions for Gregorian calendar:
        if (year % 4 > 0) return false;
        if (year % 100 == 0) return (year % 400 == 0);
        return true;
    }

    size_t shobDate::maxDays(const size_t year, const size_t mon)
    {
        if (mon != 2) return maxDaysPerMonth[mon - 1];
        return isLeapYear(year) ? 29 : 28;
    }

}
