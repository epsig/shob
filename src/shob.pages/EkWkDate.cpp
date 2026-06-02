#include "EkWkDate.h"

namespace shob::pages
{
    EkWkDate::EkWkDate(const int year) : year(year), isWk(year % 4 == 2)
    {
    }

    std::string EkWkDate::shortName() const
    {
        return (isWk ? "wk" : "ek");
    }

    std::string EkWkDate::shortNameUpper() const
    {
        return (isWk ? "WK" : "EK");
    }

    std::string EkWkDate::shortNameWithYear() const
    {
        return shortName() + std::to_string(year);
    }
}

