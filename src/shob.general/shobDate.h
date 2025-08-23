
#pragma once
#include <string>
#include <vector>

namespace shob::general
{
    static const std::vector<std::string> monthsDutch =
    { "jan", "feb", "mrt", "apr", "mei", "jun", "jul", "aug", "sep", "okt", "nov", "dec" };
    static const std::vector<size_t> maxDaysPerMonth ={ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

    class shobDate
    {
    public:
        virtual std::string toString(bool isCompatible) const { return ""; }
        virtual std::string toShortString() const { return ""; }
        static bool isLeapYear(const size_t year);
        static size_t maxDays(const size_t year, const size_t mon);
    };
}
