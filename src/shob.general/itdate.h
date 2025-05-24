#pragma once
#include <vector>

#include "shobDate.h"

namespace shob::general
{
    class itdate : public shobDate
    {
    public:
        itdate(const int dd) : dd(dd) {}
        std::string toString() const override;
        std::string toShortString() const override;
    private:
        const int dd; // date in the form 20250419
        const std::vector<std::string> months =
        { "jan", "feb", "mar", "apr", "mei", "jun", "jul", "aug", "sep", "okt", "nov", "dec" };
    };
}
