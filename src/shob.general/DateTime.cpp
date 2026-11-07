
#include "DateTime.h"

namespace shob::general
{
    DateTime::DateTime(const int yyyymmdd, const int hhmm) : yyyymmdd(yyyymmdd), hhmm(hhmm) {}

    std::string DateTime::toString() const
    {
        return std::to_string(yyyymmdd) + " " + std::to_string(hhmm);
    }

    std::string DateTime::toShortString() const
    {
        return std::to_string(yyyymmdd);
    }

}
