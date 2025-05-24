#pragma once
#include "shobDate.h"

namespace shob::general
{
    class DateTime : public shobDate
    {
    public:
        DateTime(const int yyyymmdd, const int hhmm);
        std::string toString() const override;
        std::string toShortString() const override;
    private:
        int yyyymmdd = -999; // date in the form 20250419
        int hhmm     = -999; // time in the form 2359
    };
}
