#pragma once

#include "ShobDate.h"

namespace shob::general
{
    class ItDate : public ShobDate
    {
    public:
        ItDate(const int dd) : dd(dd) {}
        std::string toString() const override;
        std::string toShortString() const override;
        int toInt() const override { return dd; }
        bool splitAndValidate(size_t& year, size_t& mon, size_t& day) const;
    private:
        const int dd; // date in the form 20250419
    };
}
