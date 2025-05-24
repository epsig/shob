
#pragma once

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
        bool splitAndValidate(size_t& year, size_t& mon, size_t& day) const;
        const int dd; // date in the form 20250419
    };
}
