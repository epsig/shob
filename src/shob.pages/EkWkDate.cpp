#include "EkWkDate.h"

namespace shob::pages
{
    EkWkDate::EkWkDate(const int year, const char DH) : year(year), DH(DH)
    {
    }

    bool EkWkDate::isWk() const
    {
        if (DH == 'H')
        {
            return year % 4 == 2;
        }
        if (year == 2019 || year == 2023) return true;
        return false;
    }

    std::string EkWkDate::shortName() const
    {
        if (DH == 'H') return (isWk() ? "wk" : "ek");
        return (isWk() ? "wkD" : "ekD");
    }

    std::string EkWkDate::shortNameUpper() const
    {
        if (DH == 'H')
        {
            return (isWk() ? "WK" : "EK");
        }
        return (isWk() ? "WKD" : "EKD");
    }

    std::string EkWkDate::shortNameWithYear() const
    {
        return shortName() + std::to_string(year);
    }
}

