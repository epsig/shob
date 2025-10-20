#include "ekwk_date.h"

namespace shob::pages
{
    ekwk_date::ekwk_date(const int year) : year(year), isWk(year % 4 == 2)
    {
    }

    std::string ekwk_date::shortName() const
    {
        return (isWk ? "wk" : "ek");
    }
}

