#include "ShobDate.h"
#include "ShobException.h"

namespace shob::general
{
    bool ShobDate:: isLeapYear(const size_t year)
    {
        // use definitions for Gregorian calendar:
        if (year % 4 > 0) return false;
        if (year % 100 == 0) return (year % 400 == 0);
        return true;
    }

    size_t ShobDate::maxDays(const size_t year, const size_t mon)
    {
        if (mon > 12) throw ShobException("Invalid month number: ", mon);

        if (mon != 2) return maxDaysPerMonth[mon - 1];
        return isLeapYear(year) ? 29 : 28;
    }

}
